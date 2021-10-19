import 'package:flutter/material.dart';
import '../models/order.dart';

import './cart.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get getOrders {
    return [..._orders];
  }

  //add all the content of the cart into one order.
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        totalAmount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  double get totalAmount {
    return totalAmount;
  }
}
