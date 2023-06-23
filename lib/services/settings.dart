import 'package:poetry_app/services/interfaces/settings_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService implements SettingsServiceI {
  late final SharedPreferences _sharedPreferences;

  SettingsService(this._sharedPreferences);

  @override
  Future<void> setNotificationTime(int hour, int minutes) async {
    await _sharedPreferences.setInt('notificationsHour', hour);
    await _sharedPreferences.setInt('notificationsMinutes', minutes);
  }

  @override
  Future<void> toggleNotifications(bool value) async {
    await _sharedPreferences.setBool('notificationsEnabled', value);
  }

  @override
  int getNotificationHour() {
    return _sharedPreferences.getInt('notificationsHour') ?? 8;
  }

  @override
  int getNotificationMinutes() {
    return _sharedPreferences.getInt('notificationsMinutes') ?? 0;
  }

  @override
  bool getNotificationsEnabled() {
    return _sharedPreferences.getBool('notificationsEnabled') ?? false;
  }

  @override
  bool getDarkModeEnabled() {
    return _sharedPreferences.getBool('darkMode_enabled') ?? false;
  }

  @override
  void setDarkMode(bool value) async {
    await _sharedPreferences.setBool('darkMode_enabled', value);
  }
}
