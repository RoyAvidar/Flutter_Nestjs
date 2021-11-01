import 'package:flutter/material.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  final bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("My Account"),
              Divider(
                height: 25,
              ),
              Text("User Name"),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("userName"),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.change_circle_outlined),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 25,
              ),
              Text("User Password"),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("userPass"),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.change_circle_outlined),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 25,
              ),
              Text("User Phone"),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("userPhone"),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.change_circle_outlined),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 25,
              ),
              if (isAdmin)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("user Products"),
                    Divider(
                      height: 25,
                    ),
                    //List of users that isAdmin = ture and the ability to change it.
                    Text("users isAdmin status"),
                    Divider(
                      height: 25,
                    ),
                    //regular user should only get hes own orders.
                    Text("get all orders")
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
