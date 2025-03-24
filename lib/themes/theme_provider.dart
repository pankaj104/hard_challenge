import 'package:flutter/material.dart';
import '../utils/theme_prefs.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final ThemePreferences _prefs = ThemePreferences();

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() async {
    int themeIndex = await _prefs.getTheme();
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.saveTheme(mode.index);
    notifyListeners();
  }

  ThemeData get lightTheme => LightTheme.theme;
  ThemeData get darkTheme => DarkTheme.theme;
}
