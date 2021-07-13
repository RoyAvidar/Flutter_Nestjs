import 'package:flutter/foundation.dart';

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem>? _items;

  Map<String, CartItem> get items {
    return {...?_items};
  }

  //counts the amount of entries in the map.
  int get itemCount {
    return _items == null ? 0 : _items!.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      //..
      _items!.update(
          productId,
          (cartItem) => CartItem(
                id: cartItem.id,
                title: cartItem.title,
                price: cartItem.price,
                quantity: cartItem.quantity! + 1,
              ));
    } else {
      _items!.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
