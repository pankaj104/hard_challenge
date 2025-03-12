import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    enableLights: true,
    ledColor: Colors.blue,
  );

  Future<void> initNotifications() async {
    // Initialize timezone
    tz.initializeTimeZones();

    var locations = tz.timeZoneDatabase.locations;
    final locationName = tz.getLocation(locations.keys.first); //Asia/Calcutta
    tz.setLocalLocation(locationName);

    // // Force device local timezone
    // final String timeZoneName = DateTime.now().timeZoneName;
    // tz.setLocalLocation(tz.getLocation(timeZoneName));
    //
    // print("🌍 Timezone Set: $timeZoneName");


    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification Clicked: ${response.payload}");
      },
    );

    // Request permission for Android 13+
    await _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }


  Future<void> scheduleNotificationAtUTC({
    required int id,
    required String title,
    required String body,
    required DateTime utcTime,
  }) async {
    // Convert UTC to Local Time
    final localTime = tz.TZDateTime.from(utcTime.toLocal(), tz.local);

    print("🔔 Scheduling Notification at (LOCAL): $localTime");
    print("⏳ Current Time (LOCAL): ${tz.TZDateTime.now(tz.local)}");

    if (localTime.isBefore(tz.TZDateTime.now(tz.local))) {
      print("⚠️ Notification time has already passed! Rescheduling for tomorrow...");
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      localTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("✅ Notification Scheduled Successfully!");
  }


  /// Function to schedule a notification at a fixed time (e.g., 10:50 AM)
  Future<void> scheduleFixedTimeNotification({
    required int id,
    required String title,
    required String body,
    required int hour, // 24-hour format (10 = 10 AM, 22 = 10 PM)
    required int minute, // Minute of the hour
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // If the time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    print("🔔 Notification Scheduled at: $scheduledTime");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidAllowWhileIdle: true, // Ensures it works in Doze Mode
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
