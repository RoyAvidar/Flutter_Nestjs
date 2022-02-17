import "package:flutter/material.dart";
import 'package:flutter_main/screens/settings/info_screen.dart';
import 'package:flutter_main/screens/settings/security_screen.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AccoutScreen extends StatelessWidget {
  const AccoutScreen({Key? key}) : super(key: key);
  static const keyPassword = 'key-password';

  @override
  Widget build(BuildContext context) {
    return SimpleSettingsTile(
      title: "Account Settings",
      subtitle: "Privacy, Security",
      leading: Icon(
        Icons.person,
        color: Colors.amber,
      ),
      child: SettingsScreen(
        children: [
          buildSecurity(context),
          buildAccountInfo(context),
          buildAccountAddress(context),
        ],
      ),
    );
  }

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
        title: "Security",
        subtitle: "",
        leading: Icon(
          Icons.security,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(SecurityScreen.routeName);
        },
      );

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
        title: "Account Info",
        subtitle: "",
        leading: Icon(
          Icons.info,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(InfoScreen.routeName);
        },
      );

  Widget buildAccountAddress(BuildContext context) => SimpleSettingsTile(
        title: "Account Addresses",
        subtitle: "",
        leading: Icon(
          Icons.library_books,
          color: Colors.green,
        ),
        onTap: () {
          //navigate to my address screen.
          // IconButton(
          //         onPressed: () {
          //           //navigate to editAddressScreen & will continue to confirmOrderScreen with editedAddressId.
          //           // Navigator.of(context).pushNamed(EditProductScreen.routeName,
          //           //     arguments: product.id);
          //         },
          //         icon: Icon(Icons.edit),
          //         color: Theme.of(context).primaryColor,
          //       ),
        },
      );
}
