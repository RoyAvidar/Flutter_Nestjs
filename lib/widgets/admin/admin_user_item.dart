import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_main/models/user.dart';
import 'package:provider/provider.dart';

class AdminUserItem extends StatefulWidget {
  const AdminUserItem({Key? key}) : super(key: key);

  @override
  _AdminUserItemState createState() => _AdminUserItemState();
}

class _AdminUserItemState extends State<AdminUserItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "${user.userName}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              height: min(20 + 50, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("User ID: "),
                      Text(user.userId.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Phone Number:"),
                      Text('${user.userPhone}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Admin Status: "),
                      user.isAdmin! ? Text("True") : Text("False")
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
