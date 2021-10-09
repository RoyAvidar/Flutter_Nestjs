import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/admin/admin_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

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
          ListTile(
            title: Text('Admin'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AdminProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
