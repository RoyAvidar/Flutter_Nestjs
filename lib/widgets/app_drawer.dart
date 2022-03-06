import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:flutter_main/screens/admin/admin_categories_screen.dart';
import 'package:flutter_main/screens/admin/admin_orders_screen.dart';
import 'package:flutter_main/screens/admin/admin_user_screen.dart';
import 'package:flutter_main/screens/reviews_screen.dart';
import 'package:flutter_main/screens/settings/settings_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

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
  String userName = "";
  var _expanded = false;

  getUser() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    } else {
      setState(() {
        isAdmin = result.data?['getSingleUser']['isAdmin'];
        userName = result.data?['getSingleUser']['userName'];
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
            title: Text('Hello, ${userName}'),
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/overView');
            },
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text('Reviews'),
            leading: Icon(Icons.reviews_outlined),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReviewsScreen.routeName);
            },
          ),
          SizedBox(height: 2),
          isAdmin
              ? ListTile(
                  title: Text('Admin'),
                  leading: Icon(Icons.edit),
                  trailing: IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                )
              : Container(),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Admin Products"),
                    leading: Icon(
                      Icons.pin_rounded,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminProductsScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: Text("Admin Orders"),
                    leading: Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminOrderScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: Text("Admin Categories"),
                    leading: Icon(
                      Icons.adjust,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminCategoryScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: Text("Admin Users"),
                    leading: Icon(
                      Icons.accessibility,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminUserScreen.routeName);
                    },
                  )
                ],
              ),
            ),
          // Divider(),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
      ),
    );
  }
}
