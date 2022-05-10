import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';

class ProductOrder with ChangeNotifier {
  final int? id;
  final int? orderId;
  final Product? product;
  final int? quantity;

  ProductOrder({
    @required this.id,
    @required this.orderId,
    @required this.product,
    @required this.quantity,
  });

  ProductOrder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderId = json['order']['orderId'],
        product = Product.fromJson(json['product']),
        quantity = json['quantity'];
}
