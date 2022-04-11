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
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryIconController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editedCateogy = Category(id: null, name: '', icon: '');

  @override
  void dispose() {
    // TODO: implement dispose
    categoryNameController.dispose();
    categoryIconController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<CategoryProvider>(context, listen: false)
        .createCategory(_editedCateogy.name!, _editedCateogy.icon!);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Category Added Successfuly!',
          textAlign: TextAlign.left,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(
              "Create Category",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    controller: categoryNameController,
                    decoration: InputDecoration(labelText: 'Name: '),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedCateogy = Category(
                        id: '-1',
                        name: value,
                        icon: _editedCateogy.icon,
                      );
                    },
                  ),
                  //should be a dropdown bar with a list of icons.
                  TextFormField(
                    controller: categoryIconController,
                    decoration: InputDecoration(labelText: 'Icon Name: '),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value.';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _editedCateogy = Category(
                        id: '-1',
                        name: _editedCateogy.name,
                        icon: value,
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Save Category",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onPressed: () {
                      _saveForm();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
