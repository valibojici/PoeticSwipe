abstract class SettingsServiceI {
  Future<void> toggleNotifications(bool value);
  Future<void> setNotificationTime(int hour, int minutes);
  bool getNotificationsEnabled();
  int getNotificationHour();
  int getNotificationMinutes();
}
