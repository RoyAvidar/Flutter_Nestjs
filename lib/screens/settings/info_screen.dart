import "dart:io";

import "package:flutter/material.dart";
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/settings/edit_profile_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

const uploadFileGraphQl = """
  mutation uploadFile(\$file: Upload!) {
    uploadFile(file: \$file)
  }
""";

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
  var _image;

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

  Future<bool> _uploadFile(MultipartFile profilePicture) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(uploadFileGraphQl),
        variables: <String, dynamic>{
          "file": profilePicture,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    //set the result as the profile pic of the user via setState..
    final isUploaded = result.data?["uploadFile"];
    return isUploaded;
  }

  Future _takePicture() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);
    setState(() async {
      _image = new MultipartFile.fromBytes(
        'file',
        await image!.readAsBytes(),
        filename: image.name,
      );
    });
  }

  Future _getGalleryImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() async {
      _image = new MultipartFile.fromBytes(
        'file',
        await image!.readAsBytes(),
        filename: image.name,
      );
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
                    ),
                    child: _image != null
                        ? Image.file(_image)
                        : Text("No Image Selected"),
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
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Choose Your Image Through"),
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
                          // Navigator.of(context).pop();
                          print(_image);
                          _uploadFile(_image);
                        },
                      ),
                    ),
                  )
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
