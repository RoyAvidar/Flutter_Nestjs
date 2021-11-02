import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getUserGraphql = """
  query {
  getSingleUser {
    userName,
    userPhone,
    isAdmin,
  }
}
""";

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAdmin = false;
  String userName = "";
  String userPhone = "";

  getUser() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    } else {
      setState(() {
        isAdmin = result.data?['getSingleUser']['isAdmin'];
        userName = result.data?['getSingleUser']['userName'];
        userPhone = result.data?['getSingleUser']['userPhone'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("${userName}'s Account"),
              Divider(
                height: 25,
              ),
              Text("User Name"),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("${userName}"),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.change_circle_outlined),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 25,
              ),
              Text("User Phone"),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("${userPhone}"),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.change_circle_outlined),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 25,
              ),
              if (isAdmin)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("get all products"),
                    Divider(
                      height: 25,
                    ),
                    //List of users that isAdmin = ture and the ability to change it.
                    Text("get all users"),
                    Divider(
                      height: 25,
                    ),
                    //regular user should only get hes own orders.
                    Text("get all orders")
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
