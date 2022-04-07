import "package:flutter/material.dart";
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:provider/provider.dart';

class AdminCreateCategoryScreen extends StatefulWidget {
  const AdminCreateCategoryScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-create-category';

  @override
  State<AdminCreateCategoryScreen> createState() =>
      Admin_CreateCategoryScreenState();
}

class Admin_CreateCategoryScreenState extends State<AdminCreateCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            "Create Category",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
