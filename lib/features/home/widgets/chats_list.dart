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
import '../../../core/utils/enums.dart';
import '../../contacts/bloc/contacts_cubit.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key, required this.chatsPagingController});
  final PagingController<int, UserChatModel> chatsPagingController;

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  HomeCubit get cubit => HomeCubit.get(context);
  ContactsCubit? contactsCubit;
  int? contactsCount;
  String? loadingStatus;
  List<Contact> allContacts = []; // Store contacts here

  void _getInitialChats() {
    widget.chatsPagingController.addPageRequestListener((pageKey) {
      cubit.getChatsNew(pageKey, widget.chatsPagingController);
    });
  }

  void _getContacts() {
    print("🎯 Starting contacts loading process...");
    setState(() => loadingStatus = "loading");

    // Create and use the cubit directly
    final cubitInstance = ContactsCubit();
    setState(() => contactsCubit = cubitInstance);

    cubitInstance.getContacts();

    cubitInstance.stream.listen((state) {
      print("🔄 ContactsCubit state changed: $state");

      if (state is GetContactsLoad) {
        setState(() => loadingStatus = "Loading contacts...");
        print("⏳ Contacts loading started");
      }
      else if (state is GetContactsSuccess) {
        setState(() {
          loadingStatus = "Success!";
          contactsCount = cubitInstance.allContacts.length;
          allContacts = cubitInstance.allContacts; // Store contacts
        });
        print("✅ Contacts loaded successfully!");
        print("📊 Total contacts: ${cubitInstance.allContacts.length}");

        // طباعة أول 5 كونتاكتس للفحص
        _printContactsSample();

        // طباعة قائمة الشات بعد تحميل الكونتاكتس
        _printChatsList();
      }
      else if (state is GetContactsError) {
        setState(() => loadingStatus = "Error: ${state.error}");
        print("❌ Error loading contacts: ${state.error}");
      }
    });
  }

  // طباعة عينة من الكونتاكتس
  void _printContactsSample() {
    print("\n📋 === قائمة الكونتاكتس (أول 5) ===");
    for (int i = 0; i < allContacts.length && i < 5; i++) {
      final contact = allContacts[i];
      print("👤 Contact ${i+1}: ${contact.displayName}");
      if (contact.phones != null && contact.phones!.isNotEmpty) {
        print("📱 Phone: ${contact.phones!.first.value}");
        print("📱 Phone Normalized: ${_normalizePhoneNumber(contact.phones!.first.value)}");
      }
      print("---");
    }
    print("📋 === نهاية قائمة الكونتاكتس ===\n");
  }

  // طباعة قائمة الشات
  void _printChatsList() {
    if (widget.chatsPagingController.itemList != null) {
      print("\n💬 === قائمة الشات ===");
      for (int i = 0; i < widget.chatsPagingController.itemList!.length; i++) {
        final chat = widget.chatsPagingController.itemList![i];
        final contact = _findContactByPhone(chat);

        print("💬 Chat ${i+1}:");
        print("   Name: ${chat.name}");
        print("   Phone: ${chat.phone}");
        print("   Phone Normalized: ${_normalizePhoneNumber(chat.phone)}");
        print("   Contact Match: ${contact?.displayName ?? 'No Match'}");
        print("---");
      }
      print("💬 === نهاية قائمة الشات ===\n");
    }
  }

  // Method to normalize phone numbers for comparison
  String? _normalizePhoneNumber(String? phone) {
    if (phone == null) return null;

    // Remove all non-digit characters
    String normalized = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Remove leading zeros and country code if needed
    if (normalized.startsWith('00')) {
      normalized = normalized.substring(2);
    }
    if (normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    }
    if (normalized.startsWith('0')) {
      normalized = normalized.substring(1);
    }

    // For Egypt numbers, you might want to handle +20
    if (normalized.startsWith('20') && normalized.length == 11) {
      normalized = normalized.substring(2);
    }

    return normalized;
  }

  // Method to find contact by phone number
  Contact? _findContactByPhone(UserChatModel userChat) {
    if (allContacts.isEmpty) return null;

    // تحويل رقم الهاتف في ال user chat للتنسيق القياسي
    String? userChatPhone = _normalizePhoneNumber(userChat.phone);

    if (userChatPhone == null) {
      print("❌ لا يوجد رقم هاتف لـ ${userChat.name}");
      return null;
    }

    for (var contact in allContacts) {
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

  @override
  void initState() {
    super.initState();
    _getInitialChats();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("🚀 initState completed, starting contacts process...");

      if (Platform.isAndroid) {
        await _checkAndroidPermissions();
      } else {
        print("🍎 iOS device, getting contacts directly...");
        _getContacts();
      }
    });
  }

  Future<void> _checkAndroidPermissions() async {
    print("🤖 Android device, checking permissions...");
    PermissionStatus permissionStatus = await _getContactPermission();
    print("🔐 Permission status: $permissionStatus");

    if (permissionStatus == PermissionStatus.granted) {
      print("✅ Permission granted, getting contacts...");
      _getContacts();
    } else {
      print("❌ Permission denied, handling error...");
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    print("📋 Initial permission status: $permission");

    if (permission != PermissionStatus.granted) {
      print("🔄 Requesting contacts permission...");
      permission = await Permission.contacts.request();
      print("📋 New permission status: $permission");
    }
    return permission;
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    setState(() => loadingStatus = "Permission denied");

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
  void dispose() {
    contactsCubit?.close();
    print("♻️ ContactsCubit disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            cubit.deleteChat(item.id);
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
  }
}