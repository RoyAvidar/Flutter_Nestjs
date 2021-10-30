import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/screens/settings_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../screens/orders_screen.dart';
import '../screens/admin/admin_products_screen.dart';

const getUserGraphql = """
  query {
  getSingleUser {
    userName,
    userPhone,
    isAdmin,
  }
}
""";

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isAdmin = false;

  getUser() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    } else {
      setState(() {
        isAdmin = result.data?['getSingleUser'].isAdmin;
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
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello, User Name'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/overView');
            },
          ),
          Divider(),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          isAdmin
              ? ListTile(
                  title: Text('Admin'),
                  leading: Icon(Icons.edit),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AdminProductsScreen.routeName);
                  },
                )
              : Container(),
          Divider(),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
      ),
    );
  }
}
