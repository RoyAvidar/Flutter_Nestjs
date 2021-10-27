import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  login() async {
    String userName = userNameController.text;
    String userPassword = userPassController.text;

    MutationOptions queryOptions = MutationOptions(
        document: gql(loginGraphQl),
        variables: <String, dynamic>{
          "userName": userName,
          "userPassword": userPassword
        });

    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);

    if (result.hasException) {
      print(result.exception);
    } else {
      // add the token to the Shared Preferences so we can use it globaly.
      final prefs = await SharedPreferences.getInstance();
      final token = result.data!['login'];
      prefs.setString('token', token);
      Navigator.of(context).pushNamed(OverviewScreen.routeName);
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
      Navigator.of(context).pushNamed(OverviewScreen.routeName);
    }
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
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
                controller: userNameController,
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: userPassController,
              ),
              SizedBox(
                height: 16,
              ),
              if (_authMode == AuthMode.Signup)
                Column(
                  children: [
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Validate Password',
                      ),
                      controller: validatePassController,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Phone',
                      ),
                      controller: userPhoneController,
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
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                  ),
                  child: Text('Login'),
                ),
              Divider(
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
              Divider(
                height: 10,
              ),
              if (_authMode == AuthMode.Login)
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text('Sign Up'),
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                )
              else
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text('Login'),
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
