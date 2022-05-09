import 'package:flutter/material.dart';

class ProductOrder with ChangeNotifier {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? quantity;

  ProductOrder({
    @required this.id,
    @required this.orderId,
    @required this.productId,
    @required this.quantity,
  });

  ProductOrder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderId = json['order']['orderId'],
        productId = json['product']['productId'],
        quantity = json['quantity'];
}
