import 'package:flutter/material.dart';
import 'package:flutter_main/providers/cart.dart';

class Order with ChangeNotifier {
  final String? id;
  final double? totalAmount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  Order({
    @required this.id,
    @required this.totalAmount,
    @required this.products,
    @required this.dateTime,
  });
}
