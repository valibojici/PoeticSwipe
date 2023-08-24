import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:PoeticSwipe/services/interfaces/settings_interface.dart';
import 'package:PoeticSwipe/services/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSharedPreferences extends Fake implements SharedPreferences {
  final Map<String, dynamic> values = {};
  @override
  bool? getBool(String key) {
    return values.containsKey(key) ? values[key] : null;
  }

  @override
  Future<bool> setBool(String key, bool value) {
    values[key] = value;
    return Future.delayed(const Duration(milliseconds: 100), () => true);
  }

  @override
  int? getInt(String key) {
    return values.containsKey(key) ? values[key] : null;
  }

  @override
  Future<bool> setInt(String key, int value) {
    values[key] = value;
    return Future.delayed(const Duration(milliseconds: 100), () => true);
  }
}

void main() {
  final getIt = GetIt.I;

  group('settings service tests:', () {
    setUpAll(() async {
      getIt.registerSingletonAsync<SettingsServiceI>(() async {
        return SettingsService(await Future.delayed(
            const Duration(milliseconds: 500), () => FakeSharedPreferences()));
      });
    });

    test('change values for settings', () async {
      SettingsServiceI settings = await getIt.getAsync<SettingsServiceI>();
      await settings.toggleNotifications(true);
      expect(settings.getNotificationsEnabled(), isTrue);

      await settings.setNotificationTime(8, 10);
      expect(settings.getNotificationHour(), equals(8));
      expect(settings.getNotificationMinutes(), equals(10));
    });
  });
}
