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

  void setTheme(ThemeType themeType) async {
    darkModeEnabled = themeType == ThemeType.dark;
    await prefs.setDarkMode(darkModeEnabled);
    notifyListeners();
  }

  static final ThemeData LightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.green,
      onPrimary: Colors.black,
      secondary: Colors.blueGrey,
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
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.grey[600],
    ),
  );

  static final ThemeData DarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.orange.shade900,
      onPrimary: Colors.white,
      secondary: Colors.blue.shade800,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[500],
    ),
  );
}
