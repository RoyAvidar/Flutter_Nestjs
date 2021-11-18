import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/screens/settings/account_settings_screen.dart';
import 'package:flutter_main/screens/settings/header_settings_screen.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

const getUserGraphql = """
  query {
  getSingleUser {
    userName,
    userPhone,
    isAdmin,
  }
}
""";

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAdmin = false;
  String userName = "";
  String userPhone = "";

  getUser() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    } else {
      setState(() {
        isAdmin = result.data?['getSingleUser']['isAdmin'];
        userName = result.data?['getSingleUser']['userName'];
        userPhone = result.data?['getSingleUser']['userPhone'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
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
                    color: Colors.black,
                  ),
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SettingsGroup(
              title: "feedback",
              children: [
                SimpleSettingsTile(
                  title: "report a bug",
                  subtitle: "",
                  leading: Icon(
                    Icons.bug_report,
                    color: Colors.black,
                  ),
                  onTap: () {},
                ),
                SimpleSettingsTile(
                  title: "Send Feedback",
                  subtitle: "",
                  leading: Icon(
                    Icons.thumb_up,
                    color: Colors.black,
                  ),
                  onTap: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
