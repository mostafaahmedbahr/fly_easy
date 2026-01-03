import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_fly_easy_new/core/notifications/fcm.dart';


class LocalNotifications with Fcm{
  final _notifications = FlutterLocalNotificationsPlugin();

  Future init(BuildContext context) async {
    const androidInitialize =
    AndroidInitializationSettings('mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await _notifications.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: backGround,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
          handleMessage(message);
        }
        // LayoutCubit.get(context).alertNotification();
      },
    );
  }

  Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          fullScreenIntent: true, // 🔥 المهم
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,

        ));
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payLoad,
    );
  }
}