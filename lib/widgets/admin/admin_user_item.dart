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
        child: ListTile(
          title: Text(
            "${user.userName}  ${user.userLastName}",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          dense: true,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              user.userProfilePic.toString().isNotEmpty
                  ? "http://10.0.2.2:8000/" + user.userProfilePic!
                  : "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg",
            ),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            color: _expanded ? Colors.black : Theme.of(context).primaryColor,
          ),
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
                      "${user.userName}  ${user.userLastName}",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    dense: true,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.userProfilePic.toString().isNotEmpty
                            ? "http://10.0.2.2:8000/" + user.userProfilePic!
                            : "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg",
                      ),
                    ),
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
                Text(
                  "User ID: ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(user.userId.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "User Email Address: ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(user.userEmail!),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Phone Number: ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text('${user.userPhone}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Admin Status: ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(user.isAdmin!.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
