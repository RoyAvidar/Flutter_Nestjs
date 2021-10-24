import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final int? categoryId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.categoryId,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        price = json['price'],
        imageUrl = json['imageUrl'],
        categoryId = int.parse(json['category']['categoryId']),
        isFavorite = false;
}
