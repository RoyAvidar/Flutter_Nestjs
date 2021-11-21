import 'package:flutter/material.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _initValues = {
    'userName': '',
    'userPhone': '',
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final userId = ModalRoute.of(context)!.settings.arguments;
    if (userId != null) {
      Provider.of<UserProvider>(context, listen: false);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 35, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "userName",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
