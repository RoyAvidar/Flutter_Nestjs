import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_main/config/gql_client.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

const getExpireDateGraphql = """
  query {
    getExpireDate(token: \$token) {
      getExpireDate
    }
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

  Future<int> _getExpireDate(String token) async {
    final token = await this.token;
    QueryOptions queryOptions =
        QueryOptions(document: gql(getExpireDateGraphql), variables: {
      'token': token,
    });
    QueryResult result = await GraphQLConfig.client.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final prefs = await SharedPreferences.getInstance();
    final expireDate = result.data?['getExpireDate'];
    prefs.setInt('expireDate', expireDate);
    print(expireDate);
    return expireDate;
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
      // print(token);
      return token;
    }
  }

  _navHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    if (expireDate != null) {
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
    _getExpireDate(token);
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
