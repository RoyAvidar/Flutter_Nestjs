import "package:flutter/material.dart";
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/settings/edit_profile_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);
  static const routeName = '/info';

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var isLoading = true;
  bool isAdmin = false;
  String userName = "";
  String userPhone = "";
  int userId = 0;

  getUser() async {
    final userData =
        await Provider.of<UserProvider>(context, listen: false).getUser();
    setState(() {
      isAdmin = userData.isAdmin!;
      userName = userData.userName!;
      userPhone = userData.userPhone!;
      userId = userData.userId!;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${userName}'s Info"),
        actions: [
          IconButton(
            onPressed: () {
              //Navigate to edit user screen.
              Navigator.of(context)
                  .pushReplacementNamed(EditProfileScreen.routeName);
            },
            icon: Icon(
              Icons.settings,
              color: Colors.green,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 15),
        child: ListView(
          children: [
            ListTile(
              title: Text("User Name:"),
              subtitle: Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              title: Text("User Phone Number:"),
              subtitle: Text(
                userPhone,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            ListTile(
              title: Text("Admin Status:"),
              subtitle: Text(
                isAdmin.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
