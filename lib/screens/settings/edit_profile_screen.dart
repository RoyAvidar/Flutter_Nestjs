import 'package:flutter/material.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();

  bool _validate = false;
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
  void dispose() {
    // TODO: implement dispose
    userNameController.dispose();
    userPhoneController.dispose();
    super.dispose();
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
              SizedBox(height: 35),
              buildTextField("Full Name", userName, userNameController),
              buildTextField("Phone Number", userPhone, userPhoneController),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        userNameController.text.isEmpty ||
                                userPhoneController.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                      });
                      if (_validate) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please Provide a Value',
                              textAlign: TextAlign.left,
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Are You Sure?"),
                            content: Text(
                              "This Procses will update your profile.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, "Cancel"),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .updateUser(
                                    userNameController.text,
                                    userPhoneController.text,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Profile Updated Successfuly!',
                                        textAlign: TextAlign.left,
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.of(context).pushReplacementNamed(
                                      SettingsScreen.routeName);
                                },
                                child: Text("Agree"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text("Update"),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 35),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 35),
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeHolder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35),
      child: TextField(
        decoration: InputDecoration(
          errorText: _validate ? "Please Enter a Value" : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeHolder,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        controller: controller,
      ),
    );
  }
}
