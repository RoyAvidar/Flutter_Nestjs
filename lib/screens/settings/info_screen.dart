import "dart:io";

import "package:flutter/material.dart";
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/settings/edit_profile_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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
  late File _profileImage;

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

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 300,
      maxWidth: 300,
    );
  }

  Future<void> _getGalleryImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300,
      maxWidth: 300,
    );
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
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 15),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          //should be the profileImageUrl of the user...
                          "https://toppng.com/uploads/preview/mario-discord-emoji-super-mario-run-wink-11563646919o32jilcf2p.png",
                        ),
                      ),
                    ),
                    // child: _profileImage != null
                    //     ? Image.file(_profileImage)
                    //     : Text("No Image."),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Colors.green[300],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.camera),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Choose Your Destiny"),
                              actions: [
                                TextButton(
                                  onPressed: _takePicture,
                                  child: Text("Camera"),
                                ),
                                TextButton(
                                  onPressed: _getGalleryImage,
                                  child: Text("Gallery"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
