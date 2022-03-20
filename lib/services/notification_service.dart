import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() => _notificationService;

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
          importance: Importance.high,
          // playSound: false,
          priority: Priority.high,
          largeIcon: FilePathAndroidBitmap(localIconPath),
          // styleInformation: styleInformation,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const IOSNotificationDetails(), 
      ),
      payload: "fasil",
    );
  }
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
