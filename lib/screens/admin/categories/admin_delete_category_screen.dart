import "package:flutter/material.dart";

class AdminDeleteCategoryScreen extends StatefulWidget {
  const AdminDeleteCategoryScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-delete-category';

  @override
  State<AdminDeleteCategoryScreen> createState() =>
      _AdminDeleteCategoryScreenState();
}

class _AdminDeleteCategoryScreenState extends State<AdminDeleteCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("hello"),
    );
  }
}
