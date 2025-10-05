import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/notifications/local_notifications.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';

Future<void> handleBackGroundMessage(RemoteMessage? message) async {
  if (message == null) return;
  if (kDebugMode) {
    print(message.data);
    print(message.messageType);
  }
  TeamChatInfoModel? chatInfo;
  if(message.data['type']==1){
    chatInfo== TeamChatInfoModel(
        id: message.data['channel_id'],
        name: message.data['channel_name'],

        image: message.data['channel_logo'], isTeam: true);
  }else{
    chatInfo= TeamChatInfoModel(
        id: message.data['user_id'],
        name: message.data['user_name'],

        userChatId: message.data['chat_user_id'],
        image: message.data['user_logo'], isTeam: false);
  }
  sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.chat,arguments: chatInfo);
  if (kDebugMode) {
    print(message.data);
  }
}

mixin Fcm {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    final res = await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      announcement: false,
      carPlay: false,
      provisional: false,
      criticalAlert: false,

    );

    print(res.notificationCenter);

  } // this request for IOS & MacOs & Web

  Future<void> fcmSettings(BuildContext context) async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    ); /* for apple notifications when received in the foreground */
    await _firebaseMessaging
        .getInitialMessage()
        .then(handleMessage); /* when the app open from terminated state */
    FirebaseMessaging.onMessageOpenedApp.listen(
      handleMessage,

    ); /*  when app is in background */
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage); /* when app is in background */
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.data);
        print(message.messageType);
      }      final notification = message.notification;
      if (message.notification != null) {
        sl<LocalNotifications>().showNotification(
          id: 0,
          title: notification!.title,
          body: notification.body,
          payLoad: jsonEncode(message.toMap()),
        );
      }
      if(message.data['type'].toString()=='1'){
        GlobalAppCubit.get(context).receiveTeamNotification(message.data['channel_id']);
      }else{
        GlobalAppCubit.get(context).receiveUserNotification(message.data['user_id']);
      }
      // sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.chat,arguments: chatInfo);
    }); /* when app is in foreground */
  }

  Future<void> initNotifications(BuildContext context) async {
    await requestPermission();
    if (context.mounted) {
      await fcmSettings(context);
    }
    if (context.mounted) {
      await sl<LocalNotifications>().init(context);
    }
  }

  void handleMessage(RemoteMessage? message) async {
    if (message == null) return;
    if (kDebugMode) {
      print(message.data);
      print(message.messageType);
    }
    if(message.data['type'].toString()=='1'){
      sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.chat,arguments: TeamChatInfoModel(
          id: message.data['channel_id'],
          name: message.data['channel_name'],

          image: message.data['channel_logo'], isTeam: true));
    }else{
      sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.chat,arguments: TeamChatInfoModel(
          id: message.data['user_id'],
          name: message.data['user_name'],

          userChatId: message.data['chat_user_id'],
          image: message.data['user_logo'], isTeam: false),

      );
    }
  } // for navigation to the required screen with required data if found

}
