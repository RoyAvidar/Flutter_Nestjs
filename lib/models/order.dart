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
      : id = json['orderId'].toString(),
        totalAmount = double.parse(json['orderPrice'].toString()),
        products = json['products']
            .map<CartItem>((pord) => CartItem.fromJson(pord))
            .toList(),
        dateTime = DateTime.parse(json['createdAt']),
        userId = json['user']['userId'].toString();
}
