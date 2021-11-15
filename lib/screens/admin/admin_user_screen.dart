import "package:flutter/material.dart";
import 'package:flutter_main/widgets/app_drawer.dart';

class AdminUserScreen extends StatelessWidget {
  const AdminUserScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello Admin"),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Text("All Users"),
      ),
    );
  }
}
