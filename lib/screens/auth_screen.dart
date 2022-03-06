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
      userName
      userPhone
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
  TextEditingController userPassController = TextEditingController();
  TextEditingController validatePassController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool _validate = false;
  var expireDate;

  @override
  void dispose() {
    userNameController.dispose();
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
    String userPassword = userPassController.text;
    String userValidatePass = validatePassController.text;
    String userPhone = userPhoneController.text;
    bool isAdmin = false;

    MutationOptions queryOptions = MutationOptions(
        document: gql(signupGraphql),
        variables: <String, dynamic>{
          "createUserInput": {
            "userName": userName,
            "userPassword": userPassword,
            "userPhone": userPhone,
            "isAdmin": isAdmin
          }
        });

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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunchies'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: userNameController,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                  controller: userPassController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              if (_authMode == AuthMode.Signup)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Validate Password',
                        ),
                        controller: validatePassController,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                        ),
                        controller: userPhoneController,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                )
              else
                Container(),
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
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 10,
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
      ),
    );
  }
}
