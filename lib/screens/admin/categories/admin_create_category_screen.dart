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
  var _dropdownValue = null;
  List<String> _icons = [];
  var _editedCateogy = Category(id: null, name: '', icon: '');

  @override
  void dispose() {
    // TODO: implement dispose
    categoryNameController.dispose();
    categoryIconController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getIcons();
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

  List<String> _getIcons() {
    final icons =
        Provider.of<CategoryProvider>(context, listen: false).getIconList;
    setState(() {
      _icons = icons;
    });
    return _icons;
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
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Icon Name:',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  //should be a dropdown bar with a list of icons.
                  DropdownButton<String>(
                    iconSize: 30,
                    iconEnabledColor: Colors.black,
                    isExpanded: true,
                    isDense: true,
                    elevation: 16,
                    style: Theme.of(context).textTheme.bodyText1,
                    value: _dropdownValue,
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    items: _icons.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value),
                            //You can use the icons directly with their literal names by accessing the Material Icons font directly with Text() widget.
                            Text(
                              value,
                              style: TextStyle(fontFamily: 'MaterialIcons'),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _editedCateogy = Category(
                        id: '-1',
                        name: _editedCateogy.name,
                        icon: value,
                      );
                      setState(() {
                        _dropdownValue = value!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      child: Text(
                        "Save Category",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      onPressed: () {
                        _saveForm();
                      },
                    ),
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
