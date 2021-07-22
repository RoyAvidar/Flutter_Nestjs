import 'package:flutter/material.dart';

import './cart.dart';

class OrderItem {
  final String? id;
  final double? totalAmount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({
    @required this.id,
    @required this.totalAmount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  //add all the content of the cart into one order.
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        totalAmount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
