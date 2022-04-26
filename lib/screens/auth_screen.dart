import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const loginGraphQl = """
    mutation login(\$userName: String!, \$userPassword: String!) {
      login(userName: \$userName, userPassword: \$userPassword)
  }
""";

const signupGraphql = """
  mutation signUp(\$createUserInput: CreateUserInput!) {
    signUp(createUserInput: \$createUserInput) {
      userName,
      userLastName,
      userEmail,
      userPhone,
      isAdmin
    }
  }
""";

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static final routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userLastNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPassController = TextEditingController();
  TextEditingController validatePassController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool _validate = false;
  bool _showPassword = true;
  var expireDate;

  @override
  void dispose() {
    userNameController.dispose();
    userLastNameController.dispose();
    userEmailController.dispose();
    userPassController.dispose();
    validatePassController.dispose();
    userPhoneController.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  _login(String userName, String userPassword) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(loginGraphQl),
        variables: <String, dynamic>{
          "userName": userName,
          "userPassword": userPassword
        });

    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);

    if (result.hasException) {
      print(result.exception);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Container(
                  height: 65,
                  child: Text(
                    'Invalid User Name or User Password, Please Try Again.',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // add the token to the Shared Preferences so we can use it globaly.
      final prefs = await SharedPreferences.getInstance();
      final token = result.data!['login'];
      prefs.setString('token', token);
      // prefs.setInt('expireDate', token);
      _getUserDarkMode();
      Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
    }
  }

  signUp() async {
    String userName = userNameController.text;
    String userLastName = userLastNameController.text;
    String userEmail = userEmailController.text;
    String userPassword = userPassController.text;
    String userValidatePass = validatePassController.text;
    String userPhone = userPhoneController.text;
    bool isAdmin = false;

    MutationOptions queryOptions = MutationOptions(
      document: gql(signupGraphql),
      variables: <String, dynamic>{
        "createUserInput": {
          "userName": userName,
          "userLastName": userLastName,
          "userEmail": userEmail,
          "userPassword": userPassword,
          "userPhone": userPhone,
          "isAdmin": isAdmin
        }
      },
    );

    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
    if (userPassword != userValidatePass) {
      return Text("Please check your password");
    }
    if (result.hasException) {
      print(result.exception);
    } else {
      //create a cart for the new user.
      _login(userName, userPassword);
    }
  }

  login() async {
    String userName = userNameController.text;
    String userPassword = userPassController.text;
    _login(userName, userPassword);
  }

  Future<bool> _getUserDarkMode() async {
    final userDarkMode = await Provider.of<UserProvider>(context, listen: false)
        .getUserDarkMode();
    // print(userDarkmode);
    userDarkMode
        ? AdaptiveTheme.of(context).setDark()
        : AdaptiveTheme.of(context).setLight();

    return userDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    // final mediaqueryData = MediaQuery.of(context);
    // mediaqueryData.padding;
    // mediaqueryData.viewInsets;
    // mediaqueryData.viewPadding;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedCrossFade(
              crossFadeState: _authMode == AuthMode.Login
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 200),
              firstChild: Column(
                children: [
                  TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'First Name',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: userNameController,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Password',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: userPassController,
                  ),
                ],
              ),
              secondChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'First Name',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: userNameController,
                  ),
                  SizedBox(height: 4),
                  TextField(
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Last Name',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: userLastNameController,
                  ),
                  SizedBox(height: 4),
                  TextField(
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Email Address',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: userEmailController,
                  ),
                  SizedBox(height: 4),
                  TextField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Password',
                      errorText: _validate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: userPassController,
                  ),
                  SizedBox(height: 4),
                  TextField(
                    obscureText: _showPassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Validate Password',
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
                    controller: validatePassController,
                  ),
                  SizedBox(height: 4),
                  TextField(
                    obscureText: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(bottom: 5),
                      labelText: 'Phone Number',
                    ),
                    controller: userPhoneController,
                  ),
                ],
              ),
            ),
            if (_authMode == AuthMode.Login)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    userNameController.text.isEmpty ||
                            userPassController.text.isEmpty
                        ? _validate = true
                        : _validate = false;
                  });
                  _validate ? () {} : login();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                ),
                child: Text('Login'),
              ),
            if (_authMode == AuthMode.Signup)
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                ),
                child: Text('Sign Up'),
              ),
            if (_authMode == AuthMode.Login)
              TextButton(
                onPressed: _switchAuthMode,
                child: Text('Sign Up'),
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
              )
            else
              TextButton(
                onPressed: _switchAuthMode,
                child: Text('Login'),
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
