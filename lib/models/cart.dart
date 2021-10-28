import 'package:flutter/material.dart';
import 'package:flutter_main/providers/cart.dart';

class Cart with ChangeNotifier {
  final int? cartId;
  final List<CartItem>? products;
  final int? totalPrice;

  Cart({
    @required this.cartId,
    @required this.products,
    @required this.totalPrice,
  });

  Cart.fromJson(Map<String, dynamic> json)
      : cartId = json['cartId'],
        totalPrice = json['totalPrice'],
        products = json['products']
            .map<CartItem>((pord) => CartItem.fromJson(pord))
            .toList();
}
