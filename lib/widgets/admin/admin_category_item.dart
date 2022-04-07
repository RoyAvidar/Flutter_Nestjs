import "package:flutter/material.dart";
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/screens/admin/categories/admin_edit_categories_screen.dart';
import 'package:provider/provider.dart';

class AdminCategoryItem extends StatefulWidget {
  const AdminCategoryItem({Key? key}) : super(key: key);

  @override
  State<AdminCategoryItem> createState() => _AdminCategoryItemState();
}

class _AdminCategoryItemState extends State<AdminCategoryItem> {
  TextEditingController categoryNameController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    // TODO: implement dispose
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Category category = Provider.of<Category>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: 16, top: 35, right: 15),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              errorText: _validate ? "Please Enter a Value" : null,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: category.name,
            ),
            controller: categoryNameController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    categoryNameController.text = "";
                  });
                },
                child: Text("Clear"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    categoryNameController.text.isEmpty
                        ? _validate = true
                        : _validate = false;
                  });
                  if (!_validate) {
                    setState(
                      () {
                        Provider.of<CategoryProvider>(context, listen: false)
                            .updateCategory(
                                category.id!,
                                categoryNameController.text,
                                categoryNameController.text);
                        category.name = categoryNameController.text;
                        categoryNameController.text = "";
                        // Navigator.of(context)
                        //     .pushNamed(AdminCategoryScreen.routeName);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Category Updated',
                              textAlign: TextAlign.left,
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
