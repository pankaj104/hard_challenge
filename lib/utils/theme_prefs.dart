import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String themeKey = "themeMode";

  Future<void> saveTheme(int themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, themeMode);
  }

  Future<int> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(themeKey) ?? 0; // 0: System, 1: Light, 2: Dark
  }
}
