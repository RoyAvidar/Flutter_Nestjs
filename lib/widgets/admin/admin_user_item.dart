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
    return AnimatedCrossFade(
      crossFadeState:
          _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 200),
      firstChild: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "${user.userName}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              dense: true,
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                color:
                    _expanded ? Colors.black : Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "${user.userName}",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    dense: true,
                    trailing: IconButton(
                      icon: Icon(
                          _expanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      color: _expanded
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
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
                Text(user.isAdmin!.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
