import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    String icon,
  ) async {
    // const styleInformation = BigPictureStyleInformation(
    //   FilePathAndroidBitmap("assets/images/Hand coding-bro.png"),
    //   largeIcon: DrawableResourceAndroidBitmap("assets/images/logo.png"),
    // );
    final localIconPath = await Utils.downloadFile(icon, "largeIcon");
    const sound = "phone_notification_sounds.mp3";
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          sound: RawResourceAndroidNotificationSound(sound.split(".").first),
          channelDescription: 'your channel description',
          importance: Importance.max,
          playSound: false,
          priority: Priority.max,
          largeIcon: FilePathAndroidBitmap(localIconPath),
          // styleInformation: styleInformation,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const IOSNotificationDetails(),
      ),
      payload: "fasil",
    );
  }

  // Future<void> cancelAllNotifications() async {
  //   await flutterLocalNotificationsPlugin.cancelAll();
  // }

  // Future<void> showScheduledNotification(
  //   int id,
  //   String title,
  //   String body,
  //   int seconds,
  // ) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'main_channel',
  //         'Main Channel',
  //         channelDescription: 'your channel description',
  //         importance: Importance.max,
  //         priority: Priority.max,
  //         icon: '@mipmap/ic_launcher',
  //       ),
  //       iOS: IOSNotificationDetails(
  //         sound: 'default.wav',
  //         presentAlert: true,
  //         presentBadge: true,
  //         presentSound: true,
  //       ),
  //     ),
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  // }
}

// ignore: avoid_classes_with_only_static_members
class Utils {
  static Future<String> downloadFile(String url, String fileName) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
