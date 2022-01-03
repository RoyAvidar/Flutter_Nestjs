import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const getExpireDateGraphql = """
  query {
    getExpireDate
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
  List<Category> categories = [];

  Future<List<Category>> getCategories() async {
    final cat = await Provider.of<CategoryProvider>(context, listen: false)
        .getCategories;
    setState(() {
      categories = cat;
    });

    return categories;
  }

  Future<int> _getExpireDate() async {
    QueryOptions queryOptions =
        QueryOptions(document: gql(getExpireDateGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
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

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    print(_token);
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
      Navigator.of(context)
          .pushNamed(OverviewScreen.routeName, arguments: categories);
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
    getCategories();
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
                "LOADING",
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
