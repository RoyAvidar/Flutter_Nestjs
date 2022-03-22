import 'package:adaptive_theme/adaptive_theme.dart';
import "package:flutter/material.dart";
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';

class HeaderScreen extends StatefulWidget {
  const HeaderScreen({Key? key}) : super(key: key);
  static const keyDarkMode = 'key-dark-mode';

  @override
  State<HeaderScreen> createState() => _HeaderScreenState();
}

class _HeaderScreenState extends State<HeaderScreen> {
  @override
  Widget build(BuildContext context) {
    //setState _userDarkMode =  userDarkMode;
    return Column(
      children: [
        buildHeader(),
        buildDarkMode(),
      ],
    );
  }

  Widget buildDarkMode() => Consumer<UserProvider>(
        builder: (co, userData, ch) => FutureBuilder<bool>(
          future: userData.getUserDarkMode(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return SwitchSettingsTile(
              settingKey: HeaderScreen.keyDarkMode,
              title: 'Change Theme',
              leading: Icon(
                Icons.dark_mode,
                color: Colors.amber,
              ),
              defaultValue: snapshot.data!,
              // defaultValue: true,
              onChange: (userDarkMode) async {
                userDarkMode =
                    await Provider.of<UserProvider>(context, listen: false)
                        .toggleUserDarkMode();
                userDarkMode
                    ? AdaptiveTheme.of(context).setDark()
                    : AdaptiveTheme.of(context).setLight();
              },
            );
          },
        ),
      );

  Widget buildHeader() => Center(
        child: Text(
          "SETTINGS",
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
}
