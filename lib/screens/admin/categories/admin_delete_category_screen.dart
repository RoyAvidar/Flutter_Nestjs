import "package:flutter/material.dart";
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/widgets/admin/admin_category_item.dart';
import 'package:provider/provider.dart';

class AdminDeleteCategoryScreen extends StatefulWidget {
  const AdminDeleteCategoryScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-delete-category';

  @override
  State<AdminDeleteCategoryScreen> createState() =>
      _AdminDeleteCategoryScreenState();
}

class _AdminDeleteCategoryScreenState extends State<AdminDeleteCategoryScreen> {
  List<Category> categories = [];

  Future<List<Category>> getCategories() async {
    final cat = await Provider.of<CategoryProvider>(context, listen: false)
        .getCategories;
    setState(() {
      categories = cat;
    });
    return categories;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            "Delete Categories",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => categories[i],
                child: Container(
                  child: Text(categories[i].name!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
