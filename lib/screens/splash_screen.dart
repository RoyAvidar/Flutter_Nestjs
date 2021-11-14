import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_main/config/gql_client.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

const getExpireDateGraphql = """
  query getExpireDate(\$token: String!) {
    getExpireDate(token: \$token) 
  }
""";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  var expireDate;

  Future<int> _getExpireDate() async {
    final prefers = await SharedPreferences.getInstance();
    final _token = prefers.getString('token');

    if (_token!.isEmpty) {
      return token;
    } else {
      setState(() {
        token = _token;
      });
      QueryOptions queryOptions = QueryOptions(
          document: gql(getExpireDateGraphql),
          variables: <String, dynamic>{
            'token': token,
          });
      QueryResult result = await GraphQLConfig.client.query(queryOptions);
      if (result.hasException) {
        print(result.exception);
      }
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        expireDate = result.data?['getExpireDate'];
        prefs.setInt('expireDate', expireDate);
      });
      return expireDate;
    }
  }

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
    if (token != null && expireDate != null) {
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
    _getToken();
    _getExpireDate();
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
