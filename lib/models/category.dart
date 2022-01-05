import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String? id;
  String? name;
  String? icon;

  Category({
    @required this.id,
    @required this.name,
    @required this.icon,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['categoryId'],
        name = json['categoryName'],
        icon = json['categoryIcon'];
}
