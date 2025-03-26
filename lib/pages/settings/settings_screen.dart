import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/pages/settings/controller/language_controller.dart';
import 'package:hard_challenge/pages/settings/widgets/premium_screen.dart';
import 'package:hard_challenge/pages/settings/widgets/section_header.dart';
import 'package:hard_challenge/pages/settings/widgets/settings_tile.dart';
import 'package:hard_challenge/pages/settings/widgets/theme_selection_bottom_sheet.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for translations
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hard_challenge/pages/settings/controller/language_controller.dart';
import 'package:hard_challenge/pages/settings/widgets/premium_screen.dart';
import 'package:hard_challenge/pages/settings/widgets/section_header.dart';
import 'package:hard_challenge/pages/settings/widgets/settings_tile.dart';
import 'package:hard_challenge/pages/settings/widgets/theme_selection_bottom_sheet.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/utils/app_strings.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '...';
 // Default placeholder
  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
  }

  Future<void> _fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version; // ✅ Ensure widget is mounted
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.settings.tr)), // ✅ Translated
      body: Container(
        color: const Color(0xffF8F8F8),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildSettingsContainer(
              context,
              children: [
                SettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  title: AppStrings.premium.tr, // ✅ Translated
                  onTap: () => _showPremiumBottomSheet(context),
                ),
              ],
            ),
            SectionHeader(title: AppStrings.appPreferences.tr), // ✅ Translated
            _buildSettingsContainer(
              context,
              children: [
                SettingsTile(
                  icon: Icons.dark_mode,
                  title: AppStrings.theme.tr, // ✅ Translated
                  onTap: () => _showThemeBottomSheet(context),
                ),
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.notifications,
                    title: AppStrings.notifications.tr), // ✅ Translated
                settingsTileDivider(),
                GetBuilder<LanguageController>(
                  builder: (controller) {
                    return SettingsTile(
                      icon: Icons.language,
                      title: AppStrings.language.tr, // ✅ Translated
                      subtitle: controller.getSavedLanguageName(),
                      onTap: () {
                        context.pushRoute(const LanguageSelectionScreen());
                      },
                    );
                  },
                ),
              ],
            ),
            SectionHeader(title: AppStrings.habitSettings.tr), // ✅ Translated
            _buildSettingsContainer(
              context,
              children: [
                SettingsTile(
                    icon: Icons.calendar_today,
                    title: AppStrings.weekStartsOn.tr,
                    subtitle: AppStrings.weekStartDay.tr), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.alarm,
                    title: AppStrings.dailyReminder.tr,
                    subtitle: 'time test'), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.timeline, title: AppStrings.streakRules.tr),
              ],
            ),
            SectionHeader(title: AppStrings.dataPrivacy.tr), // ✅ Translated
            _buildSettingsContainer(
              context,
              children: [
                SettingsTile(
                    icon: Icons.cloud_upload,
                    title: AppStrings.exportData.tr,
                  onTap: () async {
                    String? backupPath = await exportRealmDatabase();
                    if (backupPath != null) {
                      print("Backup saved at: $backupPath");
                    }
                  }

                ), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.cloud_download,
                    title: AppStrings.importData.tr,
                  onTap: () async {
                    String filePath = "/path/to/your/habit_backup.realm"; // Provide the correct path
                    await importRealmDatabase(filePath);
                  },

                ), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.privacy_tip,
                    title: AppStrings.privacyPolicy.tr), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.article,
                    title: AppStrings.termsOfService.tr), // ✅ Translated
              ],
            ),
            SectionHeader(title: AppStrings.supportAbout.tr), // ✅ Translated
            _buildSettingsContainer(
              context,
              children: [
                SettingsTile(
                    icon: Icons.help, title: AppStrings.helpCenter.tr), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.lightbulb,
                    title: AppStrings.featureRequest.tr), // ✅ Translated
                settingsTileDivider(),
                SettingsTile(
                    icon: Icons.info,
                    title: AppStrings.version.tr,
                    subtitle: _appVersion),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget settingsTileDivider() {
    return const Divider(
      thickness: 1.5,
      color: Color(0xffF3F4F6),
      height: 1,
    );
  }

  _showPremiumBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PremiumScreen(
              ctx: context,
            )),
      ),
    );
  }

  _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeSelectionBottomSheet(),
    );
  }

  Widget _buildSettingsContainer(BuildContext context, {required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }



  Future<String?> exportRealmDatabase() async {
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final realmFile = File('${appDocumentsDir.path}/default.realm');
      final backupFile = File('${appDocumentsDir.path}/habit_backup.realm');

      if (await realmFile.exists()) {
        await realmFile.copy(backupFile.path);
        return backupFile.path; // Return backup file path
      } else {
        print("No realm database found.");
        return null;
      }
    } catch (e) {
      print("Error exporting data: $e");
      return null;
    }
  }

  Future<void> importRealmDatabase(String importedFilePath) async {
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final realmFile = File('${appDocumentsDir.path}/default.realm');
      final importedFile = File(importedFilePath);

      if (await importedFile.exists()) {
        await importedFile.copy(realmFile.path);
        print("Import successful!");
      } else {
        print("Imported file not found.");
      }
    } catch (e) {
      print("Error importing data: $e");
    }
  }


}
