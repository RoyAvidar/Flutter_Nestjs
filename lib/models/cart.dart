import 'package:flutter/material.dart';
import 'package:flutter_main/providers/cart.dart';

class Cart with ChangeNotifier {
  final int? cartId;
  final List<CartItem>? products;
  int? totalPrice;
  final int? itemCount;

  Cart({
    @required this.cartId,
    @required this.products,
    @required this.totalPrice,
    @required this.itemCount,
  });

  Cart.fromJson(Map<String, dynamic> json)
      : cartId = json['cartId'],
        totalPrice = json['totalPrice'],
        itemCount = json['itemCount'],
        products = json['cartProducts']
            .map<CartItem>((pord) => CartItem.fromJson(pord))
            .toList();
}
