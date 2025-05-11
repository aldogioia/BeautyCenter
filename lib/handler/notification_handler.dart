import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHandler {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> scheduleBookingNotifications({
    required DateTime appointmentDateTime,
  }) async {
    final reminders = [
      Duration(hours: 2),
      Duration(hours: 1),
      Duration(minutes: 30),
    ];

    for (final duration in reminders) {
      final scheduledTime = appointmentDateTime.subtract(duration);

      if (scheduledTime.isAfter(DateTime.now())) {
        await _plugin.zonedSchedule(
          scheduledTime.hashCode, // Unique ID
          "Promemoria appuntamento",
          "Hai un appuntamento tra ${duration.inMinutes} minuti.",
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'booking_channel',
              'Promemoria appuntamenti',
              channelDescription: 'Notifiche per appuntamenti imminenti',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }
    }
  }
}
