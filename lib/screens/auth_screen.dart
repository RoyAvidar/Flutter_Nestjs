import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const loginGraphQl = """
  mutation {
    login(userName: "roy", userPassword: "1234")
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
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunchies'),
      ),
      body:
          // Query(
          //   options: QueryOptions(
          //     document: gql(loginGraphQl),
          //   ),
          //   builder: (QueryResult result, {fetchMore, refetch}) {
          //     if (result.hasException) {
          //       return Text(result.exception.toString());
          //     }

          //     if (result.isLoading) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                ),
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                ),
                child: Text('Sign Up'),
              )
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
