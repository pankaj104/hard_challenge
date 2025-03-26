import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hard_challenge/pages/settings/controller/language_controller.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    final languages = [
      {'name': 'English', 'native': 'English', 'locale': const Locale('en', 'US')},
      {'name': 'Español', 'native': 'Spanish', 'locale': const Locale('es', 'ES')},
      {'name': '中文', 'native': 'Chinese', 'locale': const Locale('zh', 'CN')},
      {'name': 'हिंदी', 'native': 'Hindi', 'locale': const Locale('hi', 'IN')},
      {'name': 'Français', 'native': 'French', 'locale': const Locale('fr', 'FR')},
      {'name': 'Deutsch', 'native': 'German', 'locale': const Locale('de', 'DE')},
      {'name': '日本語', 'native': 'Japanese', 'locale': const Locale('ja', 'JP')},
      {'name': 'Português', 'native': 'Portuguese', 'locale': const Locale('pt', 'PT')},
      {'name': 'العربية', 'native': 'Arabic', 'locale': const Locale('ar', 'SA')},
      {'name': 'Italiano', 'native': 'Italian', 'locale': const Locale('it', 'IT')},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Language")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your preferred language to continue",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final Locale selectedLocale = languageController.getSavedLocale();
                  final Locale langLocale = lang['locale'] as Locale;

                  final bool isSelected = selectedLocale.languageCode == langLocale.languageCode &&
                      (selectedLocale.countryCode ?? '') == (langLocale.countryCode ?? '');

                  return GestureDetector(
                    onTap: () {
                      languageController.updateLanguage(langLocale);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['name'] as String,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                lang['native'] as String,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
