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

const deleteUserProfileImageFileGraphQL = """
  mutation {
    deleteUserProfileImageFile
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
      _image = userData.userProfilePic;
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

  Future<bool> _deleteProfilePic() async {
    MutationOptions queryOptions =
        MutationOptions(document: gql(deleteUserProfileImageFileGraphQL));
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final didDeleteUserProfileImage =
        result.data?['deleteUserProfileImageFile'];
    return didDeleteUserProfileImage;
  }

  Future<bool> _takePicture() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);
    _image = new MultipartFile.fromBytes(
      'file',
      await image!.readAsBytes(),
      filename: image.name,
    );
    return true;
  }

  Future<bool> _getGalleryImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    _image = new MultipartFile.fromBytes(
      'file',
      await image!.readAsBytes(),
      filename: image.name,
    );
    return true;
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
                      image: _image == null || _image.toString().isEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg",
                              ),
                            )
                          : DecorationImage(
                              image: NetworkImage(
                                "http://10.0.2.2:8000/" + _image,
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
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
                          if (_image != null && _image.toString().isNotEmpty) {
                            _deleteProfilePic();
                          }
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Alert"),
                              content: Text("Choose Your Image Through"),
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
                              elevation: 24,
                              backgroundColor: Colors.blueGrey[200],
                            ),
                          );
                          final newImage = await _uploadFile(_image);
                          if (newImage) {
                            Navigator.of(context).pop();
                          }
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
