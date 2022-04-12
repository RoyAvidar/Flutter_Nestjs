import 'package:flutter/material.dart';

class CategoriesFilter extends StatefulWidget {
  const CategoriesFilter({Key? key, this.categoryId}) : super(key: key);
  static const routeName = '/categories-filter';

  final int? categoryId;

  @override
  State<CategoriesFilter> createState() => _CategoriesFilterState();
}

//this class/screen will get a categoryId and will generate products according to the category.
//saving time and space with just one screen insted of a lot of screens for each category...
class _CategoriesFilterState extends State<CategoriesFilter> {
  List<String> _icons = [];

  //futureBuilder getProductByCategory;

  @override
  Widget build(BuildContext context) {
    int? id = widget.categoryId;
    return Scaffold(
      body: Container(
        child: Text(
          id.toString(),
        ),
      ),
    );
  }
}
