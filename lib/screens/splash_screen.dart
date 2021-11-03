import 'package:flutter/material.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_main/config/gql_client.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    if (_token!.isEmpty) {
      return token;
    } else {
      setState(() {
        token = "Bearer $_token";
      });
      return token;
    }
  }

  _navHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    print(token);
    if (token != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OverviewScreen(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getToken();
    _navHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(
              child: Text(
                "HAMANAMA",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
