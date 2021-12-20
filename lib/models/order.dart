import 'package:flutter/material.dart';
import 'package:flutter_main/models/user.dart';
import 'package:flutter_main/providers/cart.dart';

class Order with ChangeNotifier {
  final String? id;
  final double? totalAmount;
  final List<CartItem>? products;
  final DateTime? dateTime;
  User? user;
  bool? isReady;

  Order({
    @required this.id,
    @required this.totalAmount,
    @required this.products,
    @required this.dateTime,
    this.user,
    @required this.isReady,
  });

  Order.fromJsonWithUser(Map<String, dynamic> json)
      : id = json['orderId'].toString(),
        totalAmount = double.parse(json['orderPrice'].toString()),
        products = json['products']
            .map<CartItem>((pord) => CartItem.fromJson(pord))
            .toList(),
        dateTime = DateTime.parse(json['createdAt']),
        user = User.fromJson(json['user']),
        isReady = json['isReady'];

  Order.fromJson(Map<String, dynamic> json)
      : id = json['orderId'].toString(),
        totalAmount = double.parse(json['orderPrice'].toString()),
        products = json['products']
            .map<CartItem>((pord) => CartItem.fromJson(pord))
            .toList(),
        dateTime = DateTime.parse(json['createdAt']),
        isReady = json['isReady'];
}
