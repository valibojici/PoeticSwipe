import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _notifications = FlutterLocalNotificationsPlugin();

  Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel desc',
        importance: Importance.max,
      ),
    );
  }

  Future init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('books');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterTimezone.getLocalTimezone()));
  }

  Future cancelAll() async {
    await _notifications.cancelAll();
  }

  Future scheduleDailyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    int hour = 10,
    int minute = 0,
  }) async {
    getNextDate() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    await _notifications.zonedSchedule(
      0,
      title,
      body,
      getNextDate(),
      await _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    print('notificationTapBackground()');
  }

  @pragma('vm:entry-point')
  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    print('onDidReceiveNotificationResponse()');
  }
}
