import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class NotificationHelper {
  /// Schedules a notification at a specific time.
  ///
  /// [id] is the unique identifier for the notification.
  /// [title] is the title of the notification.
  /// [body] is the body text of the notification.
  /// [scheduledTime] is the time at which the notification should trigger.
  static void scheduleNotification(int id, String title, String body, DateTime scheduledTime) {
    // Convert DateTime to TZDateTime for scheduling
    tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Schedule the notification using the NotificationService
    NotificationService().scheduleNotification(id, title, body, tzScheduledTime);
  }

  /// Cancels a scheduled notification.
  ///
  /// [id] is the unique identifier for the notification to be canceled.
  static void cancelNotification(int id) {
    NotificationService().flutterLocalNotificationsPlugin.cancel(id);
  }
}
