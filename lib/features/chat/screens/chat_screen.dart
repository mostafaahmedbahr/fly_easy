import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/cache/cache_helper.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/widgets/dialog_progress_indicator.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';

import 'package:new_fly_easy_new/features/chat/models/chat_info_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/lower_section.dart';
import 'package:new_fly_easy_new/features/chat/widgets/messages_list.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/team_chat_media_bloc/chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/user_chat_media_bloc/user_chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/team/chat_settings_screen.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/user/user_chat_settings_screen.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart' as teams;
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zim/zego_zim.dart';

import '../../../core/utils/colors.dart';
import '../bloc/chat_cubit.dart' as chat_state;
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chatInfo}) : super(key: key);
  final TeamChatInfoModel chatInfo;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  ThemeData get theme => Theme.of(context);

  ChatCubit get cubit => ChatCubit.get(context);
  final ScrollController _scrollController = ScrollController();
  bool _getMoreData = false;
  bool _hasLeftChat = false; // Track if user has left chat (read-only state)

  @override
  void initState() {
    cubit.soundPlayer = AudioPlayer();
    // Clear previous messages before loading new chat
    cubit.clearMessages();
    cubit.isInitial = true;

    // Check if user has left this chat (from persistent storage)
    _checkLeaveStatusFromStorage();

    if (widget.chatInfo.isTeam) {
      cubit.teamId = widget.chatInfo.id.toString();
      cubit.getTeamMessages();
      GlobalAppCubit.get(
        context,
      ).clearTeamChatNotifications(widget.chatInfo.id);
    } else {
      cubit.userId = widget.chatInfo.id.toString();
      cubit.getUserMessages();
      GlobalAppCubit.get(context).clearUserChatNotifications(
        widget.chatInfo.id,
        widget.chatInfo.userChatId,
      );
    }
    _scrollController.addListener(_scrollListener);
    getGetUsersInChat();
    super.initState();
  }

  // Check leave status from persistent storage
  void _checkLeaveStatusFromStorage() {
    final chatKey = widget.chatInfo.isTeam
        ? 'left_team_${widget.chatInfo.id}'
        : 'left_chat_${widget.chatInfo.id}';

    final hasLeft = CacheHelper.getData(key: chatKey) ?? false;

    if (mounted) {
      setState(() {
        _hasLeftChat = hasLeft;
      });
    }
  }

  // Save leave status to persistent storage
  void _saveLeaveStatusToStorage(bool hasLeft) {
    final chatKey = widget.chatInfo.isTeam
        ? 'left_team_${widget.chatInfo.id}'
        : 'left_chat_${widget.chatInfo.id}';

    CacheHelper.putData(key: chatKey, value: hasLeft);
  }

  // Remove chat from user's personal list only
  Future<void> _removeChatFromList() async {
    try {
      if (kDebugMode)
        print('Removing chat from personal list: ${widget.chatInfo.id}');

      // Store this chat in a "hidden chats" list so it doesn't appear in user's list
      final hiddenKey = widget.chatInfo.isTeam
          ? 'hidden_team_${widget.chatInfo.id}'
          : 'hidden_chat_${widget.chatInfo.id}';

      // Mark this chat as hidden for this user only
      await CacheHelper.putData(key: hiddenKey, value: true);

      if (mounted) {
        // Clear leave status from storage since chat is being hidden
        _saveLeaveStatusToStorage(false);

        context.pop(); // Navigate back to chat list
        AppFunctions.showToast(
          message: 'Chat removed from your list successfully',
          state: ToastStates.success,
        );
      }
    } catch (error) {
      if (kDebugMode) print('Error removing chat: $error');
      if (mounted) {
        AppFunctions.showToast(
          message: 'Failed to remove chat: $error',
          state: ToastStates.error,
        );
      }
    }
  }

  late List<Map<String, dynamic>> userIdsList = [];

  void getGetUsersInChat() async {
    zegoUserIdList = [];
    final response = await DioHelper.getData(
      path: "channels/moderators-guests/${widget.chatInfo.id}",
    );
    response.data["data"].forEach((e) {
      userIdsList.add({"id": e["id"], "name": e["name"]});
    });
    for (var element in userIdsList) {
      zegoUserIdList.add(
        ZegoCallUser(element['id'].toString(), element['name'].toString()),
      );
    }
  }

  List<ZegoCallUser> zegoUserIdList = [];
  List<Map<String, dynamic>> selectedCallers = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<ChatCubit, chat_state.ChatState>(
        listenWhen: (previous, current) =>
            current is chat_state.GetPositionLoad ||
            current is chat_state.GetPositionSuccess ||
            current is chat_state.LeaveChatLoad ||
            current is chat_state.LeaveChatSuccess,
        listener: _blocListener,
        child: Scaffold(
          backgroundColor: theme.cardColor,
          appBar: _appBar(),
          body: Column(
            children: [
              // Show status message if user has left chat
              if (_hasLeftChat)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You have left this chat',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'You can only read messages. To participate again, you need to rejoin this chat.',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Remove from list button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _removeChatFromList,
                          icon: Icon(Icons.delete_forever, size: 18.sp),
                          label: Text('Remove from List'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: MessagesList(scrollController: _scrollController),
              ),
              // Disable input section if user has left chat
              if (_hasLeftChat)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.block, color: Colors.grey, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'You cannot send messages in this chat',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const LowerSection(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  /// ///////////////////////////////////
  /// ///////// Helper Methods ///////////
  /// ///////////////////////////////////

  Future<void> _scrollListener() async {
    if (_scrollController.offset >
            _scrollController.position.maxScrollExtent - 50 &&
        !_scrollController.position.outOfRange &&
        !_getMoreData) {
      _getMoreData = true;
      await cubit.loadMoreMessages();
      await Future.delayed(const Duration(seconds: 3));
      _getMoreData = false;
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _scrollController.removeListener(_scrollListener);
    cubit.chatStream?.cancel();
    cubit.soundPlayer?.dispose();
  }

  void _showTeamSettingsScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: .8,
        child: BlocProvider(
          create: (context) => ChatMediaCubit(),
          child: ChatSettingsScreen(teamId: cubit.teamId!),
        ),
      ),
    );
  }

  void _showUserChatSettingsScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: .8,
        child: BlocProvider(
          create: (context) => UserChatMediaCubit(),
          child: UserChatSettingsScreen(userId: widget.chatInfo.id),
        ),
      ),
    );
  }

  void _showCallerSelectionDialog(bool isVideoCall) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isVideoCall
                    ? 'Select Video Call Participants'
                    : 'Select Voice Call Participants',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 300.w,
                height: 400.h,
                child: Column(
                  children: [
                    Text(
                      'Maximum 4 participants allowed',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: userIdsList.length,
                        itemBuilder: (context, index) {
                          final user = userIdsList[index];
                          final isSelected = selectedCallers.any(
                            (caller) => caller['id'] == user['id'],
                          );

                          return CheckboxListTile(
                            activeColor: AppColors
                                .lightAppBarIcon, // Blue color when selected
                            checkColor: Colors.white, // White checkmark
                            title: Text(
                              user['name'],
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            subtitle: Text(
                              'ID: ${user['id']}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  if (selectedCallers.length < 4) {
                                    selectedCallers.add(user);
                                  } else {
                                    // Show alert dialog instead of SnackBar
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                            SizedBox(width: 10),
                                            Text('تنبيه'),
                                          ],
                                        ),
                                        content: Text(
                                          'لا يمكنك اختيار أكثر من 4 أشخاص',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('موافق'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                } else {
                                  selectedCallers.removeWhere(
                                    (caller) => caller['id'] == user['id'],
                                  );
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Selected: ${selectedCallers.length}/4',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedCallers.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _makeCall(selectedCallers, isVideoCall);
                          setState(() {
                            selectedCallers.clear();
                          });
                        },
                  child: Text('Call'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _makeCall(List<Map<String, dynamic>> callers, bool isVideoCall) {
    final List<ZegoCallUser> invitees = callers.map((caller) {
      return ZegoCallUser(caller['id'].toString(), caller['name'].toString());
    }).toList();

    zegoUIKitPrebuiltCallController
        .sendCallInvitation(
          resourceID: "new_fly_easy_new",
          invitees: invitees,
          isVideoCall: isVideoCall,
          callID: widget.chatInfo.id.toString(),
        )
        .then((value) {
          if (kDebugMode) print("invitation");
          if (kDebugMode) print(value);
        })
        .catchError((e) {
          if (kDebugMode) print("invitation error");
          if (kDebugMode) print(e);
        });
  }

  void _showLeaveOptionsDialog() {
    String selectedOption = 'leave_only'; // Local variable for dialog state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.red, size: 24),
                  SizedBox(width: 10),
                  Text('Leave Chat'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose an option:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  RadioListTile<String>(
                    title: Text('Leave Chat Only'),
                    subtitle: Text('Chat will remain for other members'),
                    value: 'leave_only',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Leave and Delete Chat'),
                    subtitle: Text('Chat will be deleted only for you'),
                    value: 'leave_and_delete',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _executeLeaveAction(selectedOption),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Leave'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _executeLeaveAction(String selectedOption) async {
    if (kDebugMode)
      print('Executing leave action with option: $selectedOption');

    Navigator.of(context).pop(); // Close dialog

    try {
      if (selectedOption == 'leave_and_delete') {
        // Leave and delete - remove chat from list completely
        if (kDebugMode)
          print('Leaving and deleting chat: ${widget.chatInfo.id}');

        if (widget.chatInfo.isTeam) {
          // Delete team from teams list
          final teamsCubit = context.read<teams.TeamsCubit>();
          await teamsCubit.deleteTeam(widget.chatInfo.id);
        } else {
          // Delete user chat from chat list
          final homeCubit = context.read<HomeCubit>();
          await homeCubit.deleteChat(
            widget.chatInfo.userChatId ?? widget.chatInfo.id,
          );
        }

        if (mounted) {
          context.pop(); // Navigate back to chat list
          AppFunctions.showToast(
            message: 'Chat deleted for you successfully',
            state: ToastStates.success,
          );
        }
      } else {
        // Leave only - stay in chat but can't send messages
        if (kDebugMode)
          print('Leaving chat only (read-only): ${widget.chatInfo.id}');

        if (widget.chatInfo.isTeam) {
          await cubit.leaveTeamChat(widget.chatInfo.id);
        } else {
          await cubit.leaveUserChat(widget.chatInfo.id);
        }

        // Update UI to show read-only state
        if (mounted) {
          setState(() {
            _hasLeftChat = true; // Set leave flag
          });

          // Save leave status to persistent storage
          _saveLeaveStatusToStorage(true);

          AppFunctions.showToast(
            message: 'You have left this chat',
            state: ToastStates.success,
          );
        }
      }
    } catch (error) {
      if (kDebugMode) print('Error leaving chat: $error');
      if (mounted) {
        AppFunctions.showToast(
          message: 'Failed to leave chat: $error',
          state: ToastStates.error,
        );
      }
    }
  }

  Future<bool> _askStoragePermission() async {
    final DeviceInfoPlugin info =
        DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
      ].request(); //import 'package:permission_handler/permission_handler.dart';

      havePermission = request.values.every(
        (status) => status == PermissionStatus.granted,
      );
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      // if no permission then open app-setting
      await openAppSettings();
    }

    return havePermission;
  }

  void _blocListener(BuildContext context, chat_state.ChatState state) {
    if (state is chat_state.GetPositionLoad) {
      showDialog(
        context: context,
        builder: (context) => const DialogIndicator(),
      );
    } else if (state is chat_state.GetPositionSuccess) {
      Navigator.of(context, rootNavigator: true).pop();
    } else if (state is chat_state.LeaveChatLoad) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DialogIndicator(),
      );
    } else if (state is chat_state.LeaveChatSuccess) {
      Navigator.of(context, rootNavigator: true).pop();
      // Navigation back is handled in _executeLeaveAction
    } else if (state is chat_state.ErrorState) {
      Navigator.of(context, rootNavigator: true).pop();
      AppFunctions.showToast(message: state.error, state: ToastStates.error);
    }
  }

  /// /////////////////////////////////////
  /// /////////// Helper Widgets ///////////
  /// //////////////////////////////////////
  AppBar _appBar() => AppBar(
    backgroundColor: theme.cardColor,
    elevation: 2,
    leading: IconButton(
      onPressed: () => context.pop(),
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).primaryColor,
        size: 22.sp,
      ),
    ),
    leadingWidth: 40.w,
    title: GestureDetector(
      onTap: () {
        if (widget.chatInfo.isTeam) {
          _showTeamSettingsScreen();
        } else {
          _showUserChatSettingsScreen();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.w,
            backgroundColor: Colors.grey.withValues(alpha: .5),
            backgroundImage: CachedNetworkImageProvider(widget.chatInfo.image),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.chatInfo.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // SizedBox(
                //   height: 3.h,
                // ),
                // Text(
                //   widget.chatInfo.communityName,
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyMedium!
                //       .copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
                // )
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          if (widget.chatInfo.isTeam) {
            _showCallerSelectionDialog(false); // Voice call
          } else {
            // For individual chat, call directly
            _makeCall([
              {"id": widget.chatInfo.id, "name": widget.chatInfo.name},
            ], false);
          }
        },
        icon: Icon(IconlyLight.call, size: 22.sp),
      ),
      IconButton(
        onPressed: () {
          if (widget.chatInfo.isTeam) {
            _showCallerSelectionDialog(true); // Video call
          } else {
            // For individual chat, call directly
            _makeCall([
              {"id": widget.chatInfo.id, "name": widget.chatInfo.name},
            ], true);
          }
        },
        icon: Icon(IconlyLight.video, size: 22.sp),
      ),
      IconButton(
        onPressed: _showLeaveOptionsDialog,
        icon: Icon(IconlyLight.logout, size: 22.sp),
      ),
      SizedBox(width: 5.w),
    ],
  );
}
