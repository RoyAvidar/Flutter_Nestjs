import 'package:flutter/material.dart';
import 'package:flutter_main/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunchies'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Text(
          "Hello There",
        ),
      ),
    );
  }
}
