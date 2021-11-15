import 'package:flutter/material.dart';
import 'package:flutter_main/widgets/app_drawer.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Admin'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Text("all Orders"),
      ),
    );
  }
}
