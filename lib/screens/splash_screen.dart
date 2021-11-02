import 'package:flutter/material.dart';
// import 'package:flutter_main/config/gql_client.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

const getUserGraphql = """

""";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getToken();
  }

  // _navHome() async {
  //   await Future.delayed(Duration(milliseconds: 1500), () {});
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (ctx) => OverviewScreen()));
  // }

  // _getToken() async {
  //   return token;
  // }

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
