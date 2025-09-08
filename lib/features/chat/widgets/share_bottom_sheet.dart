import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/profile/widgets/icon_back_ground.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({Key? key, required this.chatCubit}) : super(key: key);
  final ChatCubit chatCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Center(
                child: Text(
                  LocaleKeys.share_content.tr(),
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppFonts.arial),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 15.h, left: 15.w, right: 15.w, top: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _OptionWidget(
                    icon: IconlyBold.image,
                    title: LocaleKeys.photo.tr(),
                    onTab: () {
                      chatCubit.pickImagesFromGallery();
                      context.pop();
                    },
                  ),
                  const _CustomDivider(),
                  _OptionWidget(
                    icon: Icons.video_library,
                    title: LocaleKeys.video.tr(),
                    onTab: () {
                      chatCubit.pickVideo();
                      context.pop();
                    },
                  ),
                  const _CustomDivider(),
                  _OptionWidget(
                    icon: AppIcons.document,
                    title: LocaleKeys.documents.tr(),
                    onTab: () {
                      chatCubit.pickFiles();
                      context.pop();
                    },
                  ),
                  const _CustomDivider(),
                  _OptionWidget(
                    icon: IconlyBold.profile,
                    title: LocaleKeys.contact.tr(),
                    onTab: () async {
                      context.pop();
                      if(Platform.isAndroid){
                        await _openAndroidContacts();
                      }else {
                        _openIosContacts();
                      }
                    },
                  ),
                  const _CustomDivider(),
                  _OptionWidget(
                    icon: IconlyBold.location,
                    title:LocaleKeys.share_your_location.tr(),
                    onTab: () async {
                      context.pop();
                      final permission = await Geolocator.checkPermission();
                      if(permission== LocationPermission.whileInUse){
                        chatCubit.sendLocation();
                      }else{
                        if(context.mounted){
                          AppFunctions.showAdaptiveDialog(
                            context,
                            title: 'Teams Layered collects location data to be able to send your current location in the chat',
                            actionName: 'Accept',
                            cancelName: 'Deny',
                            onPress: () => chatCubit.sendLocation(),
                          );
                        }
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  /// /////////////////////////////////////
  /// /////////// Helper Methods //////////
  /// /////////////////////////////////////

  Future<void> _openAndroidContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      sl<AppRouter>()
          .navigatorKey
          .currentState!
          .pushNamed(Routes.contacts, arguments: chatCubit);
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void>_openIosContacts()async{
    sl<AppRouter>()
        .navigatorKey
        .currentState!
        .pushNamed(Routes.contacts, arguments: chatCubit);
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
          state: ToastStates.error);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      AppFunctions.showToast(
          message: LocaleKeys.contact_not_available_on_device.tr(),
          state: ToastStates.error);
    }
  }

}

class _OptionWidget extends StatelessWidget {
  const _OptionWidget(
      {Key? key, required this.icon, required this.title, required this.onTab})
      : super(key: key);
  final IconData icon;
  final String title;
  final void Function()? onTab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Row(
        children: [
          IconBackGround(
            icon: Icon(
              icon,
              color: Theme.of(context).indicatorColor,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontFamily: AppFonts.arial, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Divider(
        height: 1.5,
        indent: 10.w,
        endIndent: 10.w,
        color: const Color(0xffF5F6F6),
      ),
    );
  }
}
