import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LanguageController extends GetxController {
  static const String languageKey = 'selectedLanguage';

  /// Mapping of language codes to their names
  final Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'zh': 'Chinese',
    'hi': 'Hindi',
    'fr': 'Français',
    'de': 'Deutsch',
    'ja': '日本語',
    'pt': 'Português',
    'ar': 'العربية',
    'it': 'Italiano',
  };

  /// Get saved locale from Hive
  Locale getSavedLocale() {
    final box = Hive.box('settingsBox');
    final String? langCode = box.get(languageKey, defaultValue: 'en_US') as String?;
    return _parseLocale(langCode ?? 'en_US'); // Ensure it's always a valid string
  }

  /// Get the language name for UI display
  String getSavedLanguageName() {
    final savedLocale = getSavedLocale();
    return languageNames[savedLocale.languageCode] ?? 'English'; // Default to English if not found
  }

  /// Update language and save to Hive
  void updateLanguage(Locale locale) {
    final box = Hive.box('settingsBox');
    final localeString = '${locale.languageCode}_${locale.countryCode ?? ''}';

    box.put(languageKey, localeString);
    Get.updateLocale(locale);
    update(); // Notify UI
  }

  /// Convert language string (e.g., `es_ES`) to `Locale`
  Locale _parseLocale(String locale) {
    final parts = locale.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }
}
