import "package:flutter/material.dart";
import 'package:flutter_main/models/user.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/widgets/admin/admin_user_item.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:flutter_main/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-user';

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  List<User> users = [];
  var isLoading = true;

  Future<List<User>> getUsers() async {
    final usersData =
        await Provider.of<UserProvider>(context, listen: false).getUsers();
    setState(() {
      users = usersData;
      isLoading = false;
    });
    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello Admin"),
        actions: [
          SearchBar(),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Text(
            "All Users",
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => users[i],
                child: AdminUserItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
