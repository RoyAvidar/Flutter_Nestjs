import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String? id;
  String? name;

  Category({
    @required this.id,
    @required this.name,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['categoryId'],
        name = json['categoryName'];
}
