import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/home/models/user_chat_model.dart';
import 'package:new_fly_easy_new/features/home/widgets/chat_widget.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import '../../../app/app_bloc/app_cubit.dart';
import '../../../core/utils/enums.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key, required this.chatsPagingController});
  final PagingController<int, UserChatModel> chatsPagingController;

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  HomeCubit get homeCubit => HomeCubit.get(context);
  GlobalAppCubit get globalCubit => GlobalAppCubit.get(context);

  void _getInitialChats() {
    widget.chatsPagingController.addPageRequestListener((pageKey) {
      homeCubit.getChatsNew(pageKey, widget.chatsPagingController);
    });
  }

  // Method to normalize phone numbers for comparison
  String? _normalizePhoneNumber(String? phone) {
    if (phone == null) return null;

    // Remove all non-digit characters except '+' at the beginning
    String normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (normalized.isEmpty) return null;

    print("📱 Original: $phone → After cleaning: $normalized");

    // Define common country codes with their expected total lengths
    final countryCodes = {
      '1': 11,     // USA/Canada: +1 10 digits
      '20': 12,    // Egypt: +20 10 digits
      '966': 12,   // Saudi Arabia: +966 9 digits
      '971': 12,   // UAE: +971 9 digits
      '973': 12,   // Bahrain: +973 8 digits
      '974': 12,   // Qatar: +974 8 digits
      '965': 12,   // Kuwait: +965 8 digits
      '968': 12,   // Oman: +968 8 digits
      '962': 12,   // Jordan: +962 9 digits
      '963': 12,   // Syria: +963 9 digits
      '961': 12,   // Lebanon: +961 8 digits
      '964': 12,   // Iraq: +964 10 digits
      '212': 12,   // Morocco: +212 9 digits
      '213': 12,   // Algeria: +213 9 digits
      '216': 12,   // Tunisia: +216 8 digits
      '218': 12,   // Libya: +218 9 digits
      '249': 12,   // Sudan: +249 9 digits
      '90': 12,    // Turkey: +90 10 digits
      '91': 12,    // India: +91 10 digits
      '92': 12,    // Pakistan: +92 10 digits
    };

    // Handle + international format
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    }
    // Handle 00 international format
    else if (normalized.startsWith('00')) {
      normalized = normalized.substring(2);
    }

    // Remove country code if present and matches known patterns
    bool countryCodeRemoved = false;
    for (final entry in countryCodes.entries) {
      final code = entry.key;
      final totalLength = entry.value;

      if (normalized.startsWith(code) && normalized.length == totalLength) {
        normalized = normalized.substring(code.length);
        countryCodeRemoved = true;
        print("🌍 Removed country code: $code");
        break;
      }
    }

    // Handle local numbers with leading 0 (if no country code was removed)
    if (!countryCodeRemoved && normalized.startsWith('0')) {
      normalized = normalized.substring(1);
      print("🔧 Removed leading zero");
    }

    // Final cleanup - remove any remaining non-digit characters
    normalized = normalized.replaceAll(RegExp(r'[^\d]'), '');

    // Validate length - most local numbers are 8-10 digits
    if (normalized.length < 8 || normalized.length > 10) {
      print("⚠️ Invalid phone length: ${normalized.length} for $phone");
      return null;
    }

    print("✅ Final normalized: $normalized");
    return normalized;
  }

  // Method to find contact by phone number
  Contact? _findContactByPhone(UserChatModel userChat) {
    if (globalCubit.allContacts.isEmpty) return null;

    // تحويل رقم الهاتف في ال user chat للتنسيق القياسي
    String? userChatPhone = _normalizePhoneNumber(userChat.phone);

    if (userChatPhone == null) {
      return null;
    }

    for (var contact in globalCubit.allContacts) {
      if (contact.phones != null && contact.phones!.isNotEmpty) {
        for (var phone in contact.phones!) {
          String? contactPhone = _normalizePhoneNumber(phone.value);
          if (contactPhone != null && contactPhone == userChatPhone) {
            return contact;
          }
        }
      }
    }

    return null;
  }

  Future<void> _checkPermissionsAndLoadContacts() async {
    if (Platform.isAndroid) {
      await _checkAndroidPermissions();
    } else {
      // For iOS, the permission is already handled in GlobalAppCubit
      print("🍎 iOS device - contacts should be loaded automatically");
    }
  }

  Future<void> _checkAndroidPermissions() async {
    print("🤖 Android device, checking permissions...");
    PermissionStatus permissionStatus = await _getContactPermission();
    print("🔐 Permission status: $permissionStatus");

    if (permissionStatus == PermissionStatus.granted) {
      print("✅ Permission granted");
      // Contacts are already loaded by GlobalAppCubit
    } else {
      print("❌ Permission denied, handling error...");
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
    }
    return permission;
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      AppFunctions.showToast(
        message: LocaleKeys.access_to_contact_denied.tr(),
        state: ToastStates.error,
      );
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      AppFunctions.showToast(
        message: LocaleKeys.contact_not_available_on_device.tr(),
        state: ToastStates.error,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getInitialChats();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("🚀 initState completed, checking permissions...");
      await _checkPermissionsAndLoadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalAppCubit, GlobalAppState>(
      builder: (context, state) {
        return RefreshIndicator.adaptive(
          onRefresh: () async => widget.chatsPagingController.refresh(),
          color: AppColors.lightPrimaryColor,
          child: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => current is DeleteChatSuccess,
            builder: (context, state) => PagedListView.separated(
              padding: EdgeInsets.only(bottom: 10.h),
              pagingController: widget.chatsPagingController,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              builderDelegate: PagedChildBuilderDelegate<UserChatModel>(
                itemBuilder: (context, item, index) {
                  // Find contact for this specific chat item by phone number
                  final contact = _findContactByPhone(item);

                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: .25,
                      children: [
                        SlidableAction(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          backgroundColor: Colors.red,
                          autoClose: true,
                          onPressed: (context) {
                            AppFunctions.showAdaptiveDialog(
                              context,
                              title: LocaleKeys.do_you_want_delete_chat.tr(),
                              actionName: LocaleKeys.delete.tr(),
                              onPress: () {
                                homeCubit.deleteChat(item.id);
                              },
                            );
                          },
                          icon: AppIcons.delete,
                        ),
                        SizedBox(width: 5.w),
                      ],
                    ),
                    child: ChatWidget(
                      userChat: item,
                      contact: contact, // Pass single contact to ChatWidget
                    ),
                  );
                },
                firstPageProgressIndicatorBuilder: (_) =>
                const Center(child: MyProgress()),
                firstPageErrorIndicatorBuilder: (context) =>
                    TeamsErrorView(message: widget.chatsPagingController.error),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: EmptyWidget(
                    text: LocaleKeys.no_chats.tr(),
                    image: AppImages.emptyChats,
                    repeat: false,
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) =>
                const Center(child: MyProgress()),
              ),
            ),
          ),
        );
      },
    );
  }
}