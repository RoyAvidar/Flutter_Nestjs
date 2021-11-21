import "package:flutter/material.dart";

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);
  static const routeName = '/security';

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security"),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text("Password"),
            )
          ],
        ),
      ),
    );
  }
}
