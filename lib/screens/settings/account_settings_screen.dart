import "package:flutter/material.dart";
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccoutScreen extends StatelessWidget {
  const AccoutScreen({Key? key}) : super(key: key);
  static const keyPassword = 'key-password';

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: "Account Settings",
      subtitle: "Privacy, Security, Language",
      leading: Icon(
        Icons.person,
        color: Colors.black,
      ),
      child: SettingsScreen(
        children: [
          buildPrivacy(context),
          buildSecurity(context),
          buildAccountInfo(context),
        ],
      ),
    );
  }

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
        title: "Privacy",
        subtitle: "",
        leading: Icon(
          Icons.lock,
          color: Colors.black,
        ),
        onTap: () {},
      );

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
        title: "Security",
        subtitle: "",
        leading: Icon(
          Icons.security,
          color: Colors.black,
        ),
        onTap: () {},
      );

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
        title: "Account Info",
        subtitle: "",
        leading: Icon(
          Icons.info,
          color: Colors.black,
        ),
        onTap: () {},
      );
}
