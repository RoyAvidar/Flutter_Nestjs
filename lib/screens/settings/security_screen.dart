import "package:flutter/material.dart";
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:provider/provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);
  static const routeName = '/security';

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  TextEditingController userOldPassController = TextEditingController();
  TextEditingController userNewPassController = TextEditingController();
  TextEditingController userValidPassController = TextEditingController();
  bool _validate = false;
  bool _showPassword = true;

  Future<bool> changePassword(String newPassword) async {
    await Provider.of<UserProvider>(context, listen: false)
        .changePassword(newPassword);
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose]
    userOldPassController.dispose();
    userNewPassController.dispose();
    userValidPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // return GestureDetector
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Security"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Current Password',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: userOldPassController,
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'New Password',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: userNewPassController,
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Valid Password',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  controller: userValidPassController,
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      userNewPassController.text.isEmpty ||
                              userValidPassController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                    // changePass();
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Are You Sure?"),
                        content:
                            Text("This Procses will change your password."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, "Cancel"),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              if (userNewPassController.text ==
                                      userValidPassController.text &&
                                  !_validate) {
                                changePassword(userNewPassController.text);
                                Navigator.of(context)
                                    .pushNamed(OverviewScreen.routeName);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Password Change Successfuly!',
                                      textAlign: TextAlign.left,
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Agree"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                  ),
                  child: Text('Change Password'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, "Cancel"),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
