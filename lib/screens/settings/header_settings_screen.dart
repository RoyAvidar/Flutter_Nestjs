import 'package:adaptive_theme/adaptive_theme.dart';
import "package:flutter/material.dart";
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen({Key? key}) : super(key: key);
  static const keyDarkMode = 'key-dark-mode';

  @override
  Widget build(BuildContext context) {
    //setState _userDarkMode =  userDarkMode;
    return Column(
      children: [
        buildHeader(),
        buildDarkMode(context),
      ],
    );
  }

  Widget buildDarkMode(context) => SwitchSettingsTile(
        settingKey: keyDarkMode,
        title: 'Change Theme',
        leading: Icon(
          Icons.dark_mode,
          color: Colors.amber,
        ),
        onChange: (userDarkMode) async {
          userDarkMode = await Provider.of<UserProvider>(context, listen: false)
              .toggleUserDarkMode();
          userDarkMode
              ? AdaptiveTheme.of(context).setDark()
              : AdaptiveTheme.of(context).setLight();
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
