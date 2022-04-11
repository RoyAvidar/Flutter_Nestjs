import "package:flutter/material.dart";
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/screens/admin/categories/admin_edit_categories_screen.dart';
import 'package:flutter_main/screens/admin/categories/admin_main_categories_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AdminCategoryItem extends StatefulWidget {
  const AdminCategoryItem({Key? key, this.isEditCategory}) : super(key: key);

  final bool? isEditCategory;

  @override
  State<AdminCategoryItem> createState() => _AdminCategoryItemState();
}

class _AdminCategoryItemState extends State<AdminCategoryItem> {
  TextEditingController categoryNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editedCateogy = Category(id: null, name: '', icon: '');

  @override
  void dispose() {
    // TODO: implement dispose
    categoryNameController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<CategoryProvider>(context, listen: false).updateCategory(
        _editedCateogy.id!, _editedCateogy.name!, _editedCateogy.icon!);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Category Edited Successfuly!',
          textAlign: TextAlign.left,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<Category>(context, listen: false);
    final isEditCategory = widget.isEditCategory;

    Future<bool> deleteCategory() async {
      final isDeleted = Provider.of<CategoryProvider>(context, listen: false)
          .deleteCategory(category.id!);
      return isDeleted;
    }

    return Column(
      children: [
        ListTile(
          title: Text('Name: ' + category.name!),
          subtitle: Text('Icon: ' + category.icon!),
          trailing: isEditCategory!
              ? IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.green,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextFormField(
                                      initialValue: category.name,
                                      decoration:
                                          InputDecoration(labelText: 'Name:'),
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
                                          id: category.id,
                                          name: value,
                                          icon: _editedCateogy.icon,
                                        );
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: category.icon,
                                      decoration:
                                          InputDecoration(labelText: 'Icon:'),
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
                                          id: category.id,
                                          name: _editedCateogy.name,
                                          icon: value,
                                        );
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Save Changes",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      onPressed: () {
                                        _saveForm();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -85.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: TextButton(
                                  onPressed: () {
                                    deleteCategory();
                                    Navigator.of(context).pushNamed(
                                        AdminMainCategoriesScreen.routeName);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Category Deleted Successfuly!',
                                          textAlign: TextAlign.left,
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Text("Delete category"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
