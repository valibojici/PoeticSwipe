import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:poetry_app/services/interfaces/settings_interface.dart';

enum ThemeType { light, dark }

class ThemeProvider with ChangeNotifier {
  bool darkModeEnabled = false;
  late final SettingsServiceI prefs;
  ThemeData get theme => darkModeEnabled ? DarkTheme : LightTheme;

  ThemeProvider() {
    init();
  }

  void init() async {
    prefs = await GetIt.I.getAsync<SettingsServiceI>();
    darkModeEnabled = prefs.getDarkModeEnabled();
    notifyListeners();
  }

  void setTheme(ThemeType themeType) {
    darkModeEnabled = themeType == ThemeType.dark;

    notifyListeners();
  }

  static final ThemeData LightTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(shadowColor: Colors.transparent),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.teal,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: Colors.white,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[600],
      ));

  static final ThemeData DarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
  );
}
