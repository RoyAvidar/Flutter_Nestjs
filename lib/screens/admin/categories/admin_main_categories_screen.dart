import "package:flutter/material.dart";
import 'package:flutter_main/screens/admin/categories/admin_create_category_screen.dart';
import 'package:flutter_main/screens/admin/categories/admin_delete_category_screen.dart';
import 'package:flutter_main/screens/admin/categories/admin_edit_categories_screen.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AdminMainCategoriesScreen extends StatefulWidget {
  const AdminMainCategoriesScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-main-categories';

  @override
  State<AdminMainCategoriesScreen> createState() =>
      _AdminMainCategoriesScreenState();
}

class _AdminMainCategoriesScreenState extends State<AdminMainCategoriesScreen> {
  //will be a list view of all the pages for categories(create/edit/delete).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Admin'),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            SimpleSettingsTile(
              title: "Add a Category",
              subtitle: "",
              leading: Icon(
                Icons.create_sharp,
                color: Colors.green[300],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AdminCreateCategoryScreen.routeName);
              },
            ),
            SimpleSettingsTile(
              title: "Edit a Category",
              subtitle: "",
              leading: Icon(
                Icons.edit_attributes,
                color: Colors.green[300],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AdminEditCategoryScreen.routeName);
              },
            ),
            SimpleSettingsTile(
              title: "Delete a Category",
              subtitle: "",
              leading: Icon(
                Icons.delete_sharp,
                color: Colors.red[300],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AdminDeleteCategoryScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
