import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final int? categoryId;

  Product({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.categoryId,
  });

  // void toggleFavorite() {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['productId'].toString(),
        name = json['productName'],
        description = json['productDesc'],
        price = double.parse(json['productPrice'].toString()),
        imageUrl = json['imageUrl'],
        categoryId = int.parse(json['category']['categoryId']);
}
