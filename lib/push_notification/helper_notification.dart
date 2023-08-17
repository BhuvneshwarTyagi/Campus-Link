import 'package:campus_link_teachers/push_notification/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServices{
  RequestPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // notification permission is granted
    }
    else {
      // Open settings to enable notification permission
    }
  }
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel("campuslink", "campuslink channel",
        importance: Importance.max, playSound: true);


    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings());

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    _notificationsPlugin.initialize(initializationSettings);
        // onSelectNotification: (String? route) async {
        //   if (route != null) {
        //     //Navigator.of(context).pushNamed(route);
        //   }
        // });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            "campuslink",
            "campuslink channel",
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: IOSNotificationDetails());

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            "campuslink",
            "campuslink channel",
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher'
        ),
        iOS: IOSNotificationDetails());
  }

  static void onMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;
    if (notification == null) return;
    if (androidNotification != null || appleNotification != null) {
      _notificationsPlugin.show(notification.hashCode, notification.title,
          notification.body, _notificationDetails());
    }
  }

  void setUserState({required UserState userState}) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    int stateNum = Utils.stateToNum(userState);
    FirebaseFirestore.instance.collection("Students").doc(userId).update({
      "state": stateNum,
      "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

}
