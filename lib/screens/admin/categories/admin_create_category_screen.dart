import "package:flutter/material.dart";

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
      body: Text("hello"),
    );
  }
}
