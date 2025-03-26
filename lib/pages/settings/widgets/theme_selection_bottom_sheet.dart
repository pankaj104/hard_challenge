import 'package:flutter/material.dart';
import 'package:hard_challenge/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSelectionBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ThemeMode selectedMode = themeProvider.themeMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Choose Theme",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 6),

          // Light Mode Option
          _buildThemeOption(
            context,
            title: "Light",
            icon: Icons.wb_sunny_outlined,
            mode: ThemeMode.light,
            selectedMode: selectedMode,
            onChanged: (mode) => themeProvider.setTheme(mode),
          ),

          // Dark Mode Option
          _buildThemeOption(
            context,
            title: "Dark",
            icon: Icons.nightlight_round,
            mode: ThemeMode.dark,
            selectedMode: selectedMode,
            onChanged: (mode) => themeProvider.setTheme(mode),
          ),

          // System Mode Option
          _buildThemeOption(
            context,
            title: "Use System Setting",
            icon: Icons.settings,
            mode: ThemeMode.system,
            selectedMode: selectedMode,
            onChanged: (mode) => themeProvider.setTheme(mode),
          ),
        ],
      ),
    );
  }

  /// Helper function to build a theme option row
  Widget _buildThemeOption(
      BuildContext context, {
        required String title,
        required IconData icon,
        required ThemeMode mode,
        required ThemeMode selectedMode,
        required Function(ThemeMode) onChanged,
      }) {
    return ListTile(
      leading: Radio<ThemeMode>(
        value: mode,
        groupValue: selectedMode,
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
            Navigator.pop(context); // Close bottom sheet after selection
          }
        },
      ),
      title: Text(title),
      trailing: Icon(icon),
      onTap: () {
        onChanged(mode);
        Navigator.pop(context); // Close bottom sheet
      },
    );
  }
}
