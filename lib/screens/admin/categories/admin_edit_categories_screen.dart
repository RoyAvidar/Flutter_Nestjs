import 'package:flutter/material.dart';
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/widgets/admin/admin_category_item.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class AdminEditCategoryScreen extends StatefulWidget {
  const AdminEditCategoryScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-edit-category';

  @override
  State<AdminEditCategoryScreen> createState() =>
      _AdminEditCategoryScreenState();
}

class _AdminEditCategoryScreenState extends State<AdminEditCategoryScreen> {
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
      appBar: AppBar(
        title: Text('Hello Admin'),
      ),
      // drawer: AppDrawer(),
      body: Column(
        children: [
          Text(
            "Edit Categories",
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
              child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: categories.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => categories[i],
                child: AdminCategoryItem(),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
