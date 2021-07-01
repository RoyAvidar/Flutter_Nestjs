// import 'package:flutter/material.dart';

class OrderItem {
  final String orderId;
  final String productId;
  final double orderPrice; // quantity of item * price
  final DateTime createdAt;
  // final List<Product> products;

  OrderItem(
    this.orderId,
    this.productId,
    this.orderPrice,
    this.createdAt,
    // @required this.products,
  );
}
