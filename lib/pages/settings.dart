import 'package:flutter/material.dart';
import 'package:pirim_depo/utils/text.dart';
import 'package:provider/provider.dart';
import '../theme/theme_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              themeText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Switch(
              value: themeManager.currentThemeMode == ThemeModeType.dark,
              activeColor: Colors.white,
              onChanged: (value) {
                themeManager.toggleTheme();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
