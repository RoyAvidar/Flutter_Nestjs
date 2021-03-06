import 'package:flutter/material.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/create_review_screen.dart';
import 'package:flutter_main/screens/report_bug_screen.dart';
import 'package:flutter_main/screens/reviews_screen.dart';
import 'package:flutter_main/screens/settings/account_settings_screen.dart';
import 'package:flutter_main/screens/settings/header_settings_screen.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<bool> deleteUser() async {
    await Provider.of<UserProvider>(context, listen: false).deleteUser();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            HeaderScreen(),
            SettingsGroup(
              title: 'General',
              children: [
                AccoutScreen(),
                SimpleSettingsTile(
                  title: "Delete Account",
                  subtitle: "",
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Are You Sure?"),
                        content: Text(
                            "You will not be able to restore this account!"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, "Oops"),
                            child: Text("Oops"),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteUser();
                              Navigator.of(context)
                                  .pushReplacementNamed(AuthScreen.routeName);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Account Deleted Successfuly!',
                                    textAlign: TextAlign.left,
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text("HIT IT!"),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SettingsGroup(
              title: "Feedback",
              children: [
                SimpleSettingsTile(
                  title: "Report a Bug",
                  subtitle: "",
                  leading: Icon(
                    Icons.bug_report,
                    color: Colors.orange[200],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(ReportBugScreen.routeName);
                  },
                ),
                SimpleSettingsTile(
                  title: "Send Feedback",
                  subtitle: "",
                  leading: Icon(
                    Icons.thumb_up,
                    color: Colors.green,
                  ),
                  onTap: () {
                    //create a review
                    Navigator.of(context)
                        .pushNamed(CreateReviewScreen.routeName);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
