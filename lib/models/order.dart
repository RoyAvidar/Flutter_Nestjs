import 'package:flutter/material.dart';
import 'package:flutter_main/providers/cart.dart';

class Order with ChangeNotifier {
  final String? id;
  final double? totalAmount;
  final List<CartItem>? products;
  final DateTime? dateTime;
  final String? userId;

  Order({
    @required this.id,
    @required this.totalAmount,
    @required this.products,
    @required this.dateTime,
    @required this.userId,
  });

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        totalAmount = json['totalAmount'],
        products = json['products'],
        dateTime = json['dateTime'],
        userId = json['userId'];
}
