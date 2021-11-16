import "package:flutter/material.dart";
import 'package:flutter_main/models/category.dart';
import 'package:provider/provider.dart';

class AdminCategoryItem extends StatelessWidget {
  const AdminCategoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<Category>(context, listen: false);
    return ListTile(
      title: Text(category.name!),
      leading: Text(category.id!),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {},
      ),
    );
  }
}
