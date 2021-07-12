import 'package:flutter/material.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'c1',
      name: 'Test',
      description: 'This is a test',
      price: 9.99,
      imageUrl:
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/14C52/production/_92847058_c3c1256f-1f69-45fe-ade5-a1822e3d9b9c.jpg',
      categoryName: 'Sandwich',
      // isFavorite: true,
    ),
    Product(
      id: 'c2',
      name: 'Test2',
      description: 'This is a test2',
      price: 8.99,
      imageUrl:
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/14C52/production/_92847058_c3c1256f-1f69-45fe-ade5-a1822e3d9b9c.jpg',
      categoryName: 'Salad',
    ),
    Product(
      id: 'c3',
      name: 'Test3',
      description: 'This is a test3',
      price: 7.99,
      imageUrl:
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/14C52/production/_92847058_c3c1256f-1f69-45fe-ade5-a1822e3d9b9c.jpg',
      categoryName: 'Lunch',
    ),
    Product(
      id: 'c4',
      name: 'Test4',
      description: 'This is a test4',
      price: 6.99,
      imageUrl:
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/14C52/production/_92847058_c3c1256f-1f69-45fe-ade5-a1822e3d9b9c.jpg',
      categoryName: 'Sandwich',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
