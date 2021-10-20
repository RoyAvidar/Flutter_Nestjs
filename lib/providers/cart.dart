import 'package:flutter/foundation.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const getCartGraphql = """
  query {
    getcart(\$cartId: cartId) {
      user {
        userId
      }
    }
  }
""";

const createCartGraphql = """
  mutation {
    createCart(\$createCartData: CreateCartData!) {
      createCart(createCartData: \$createCartData) {
        cartId
      }
    }
  }
""";

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
  Map<String, CartItem>? _items = {};

  Future<String> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    return token!;
  }

  void createCart(int userId, int totalPrice) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(createCartGraphql),
        variables: <String, dynamic>{
          "createCartData": {
            "userId": userId,
            "totalPrice": totalPrice,
          }
        });
    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
  }

  Map<String, CartItem> get items {
    return {...?_items};
  }

  //counts the amount of entries in the map.
  int get itemCount {
    return _items!.length;
  }

  //counts the total price of the cartItems in the cart.
  double get totalAmount {
    var total = 0.0;
    _items!.forEach((key, cartItem) {
      total += cartItem.price! * cartItem.quantity!.toDouble();
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      //change quantity...
      _items!.update(
        productId,
        (cartItem) => CartItem(
          id: cartItem.id,
          title: cartItem.title,
          price: cartItem.price,
          quantity: cartItem.quantity! + 1,
        ),
      );
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

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  //single quantity of the product.
  void removeSingleItem(String productId) {
    if (!_items!.containsKey(productId)) {
      return;
    }
    if (_items![productId]!.quantity! > 1) {
      _items!.update(
          productId,
          (cartItem) => CartItem(
                id: cartItem.id,
                title: cartItem.title,
                quantity: cartItem.quantity! - 1,
                price: cartItem.price,
              ));
    } else {
      _items!.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
