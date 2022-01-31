import "package:flutter/material.dart";
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen({Key? key}) : super(key: key);
  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        buildDarkMode(),
      ],
    );
  }

  Widget buildDarkMode() => SwitchSettingsTile(
        settingKey: keyDarkMode,
        title: 'Change Theme',
        leading: Icon(
          Icons.dark_mode,
          color: Colors.amber,
        ),
        onChange: (userDarkMode) async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('userDarkMode', userDarkMode);
        },
      );

  Widget buildHeader() => Center(
        child: Text(
          "SETTINGS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.redAccent,
          ),
        ),
      );
}
