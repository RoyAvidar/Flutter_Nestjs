import "package:flutter/material.dart";
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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
        onChange: (_) {},
      );

  Widget buildHeader() => Center(
        child: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.teal[300],
          ),
        ),
      );
}
