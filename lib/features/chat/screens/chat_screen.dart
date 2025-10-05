import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/widgets/dialog_progress_indicator.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/lower_section.dart';
import 'package:new_fly_easy_new/features/chat/widgets/messages_list.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/team_chat_media_bloc/chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/user_chat_media_bloc/user_chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/team/chat_settings_screen.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/user/user_chat_settings_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../contacts/bloc/contacts_cubit.dart';
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatInfo,
  }) : super(key: key);
  final TeamChatInfoModel chatInfo;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  ThemeData get theme => Theme.of(context);

  ChatCubit get cubit => ChatCubit.get(context);
  ContactsCubit get contactsCubit => ContactsCubit.get(context);
  final ScrollController _scrollController = ScrollController();
  bool _getMoreData = false;

  @override
  void initState() {
    Future.microtask(() => contactsCubit.getContacts());
    cubit.soundPlayer = AudioPlayer();
    if (widget.chatInfo.isTeam) {
      cubit.teamId = widget.chatInfo.id.toString();
      cubit.getTeamMessages();
      GlobalAppCubit.get(context).clearTeamChatNotifications(widget.chatInfo.id);
    } else {
      cubit.userId = widget.chatInfo.id.toString();
      cubit.getUserMessages();
      GlobalAppCubit.get(context).clearUserChatNotifications(
          widget.chatInfo.id, widget.chatInfo.userChatId);
    }
    _scrollController.addListener(_scrollListener);
    getGetUsersInChat();
    super.initState();
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
        ZegoCallUser(
          element['id'].toString(),
          element['name'].toString(),
        ),
      );
    }
  }

  List<ZegoCallUser> zegoUserIdList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) =>
            current is GetPositionLoad || current is GetPositionSuccess,
        listener: _blocListener,
        child: Scaffold(
          backgroundColor: theme.cardColor,
          appBar: _appBar(),
          body: Column(
            children: [
              Expanded(
                  child: MessagesList(
                scrollController: _scrollController,
              )),
              const LowerSection()
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
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      builder: (context) => FractionallySizedBox(
        heightFactor: .8,
        child: BlocProvider(
            create: (context) => ChatMediaCubit(),
            child: ChatSettingsScreen(
              teamId: cubit.teamId!,
            )),
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
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      builder: (context) => FractionallySizedBox(
        heightFactor: .8,
        child: BlocProvider(
            create: (context) => UserChatMediaCubit(),
            child: UserChatSettingsScreen(
              userId: widget.chatInfo.id,
            )),
      ),
    );
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

      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
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

  void _blocListener(BuildContext context, ChatState state) {
    if (state is GetPositionLoad) {
      showDialog(
        context: context,
        builder: (context) => const DialogIndicator(),
      );
    } else if (state is GetPositionSuccess) {
      Navigator.of(context, rootNavigator: true).pop();
    } else if (state is ErrorState) {
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
            )),
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
                backgroundColor: Colors.grey.withOpacity(.5),
                backgroundImage:
                    CachedNetworkImageProvider(widget.chatInfo.image),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "widget.chatInfo.phone.toString()",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 16.sp, fontWeight: FontWeight.w700),
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
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                zegoUIKitPrebuiltCallController
                    .sendCallInvitation(
                      resourceID: "new_fly_easy_new",
                      invitees: widget.chatInfo.isTeam
                          ? zegoUserIdList
                          : [
                              ZegoCallUser(
                                widget.chatInfo.id.toString(),
                                widget.chatInfo.name.toString(),
                              )
                            ],
                      isVideoCall: false,
                      callID: widget.chatInfo.id.toString(),
                    )
                    .then((value) => print(value))
                    .catchError((e) {});
              },
              icon: Icon(
                IconlyLight.call,
                size: 22.sp,
              )),
          IconButton(
            onPressed: () {
              zegoUIKitPrebuiltCallController
                  .sendCallInvitation(
                    resourceID: "new_fly_easy_new",
                    invitees: widget.chatInfo.isTeam
                        ? zegoUserIdList
                        : [
                            ZegoCallUser(
                              widget.chatInfo.id.toString(),
                              widget.chatInfo.name.toString(),
                            )
                          ],
                    isVideoCall: true,
                    callID: widget.chatInfo.id.toString(),
                  )
                  .then((value) {
                print("invitation");
                print(value);
              })
                  .catchError((e) {
                    print("invitation error");
                    print(e);
              });
            },
            icon: Icon(
              IconlyLight.video,
              size: 22.sp,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
        ],
      );
}
