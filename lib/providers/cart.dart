import 'package:flutter/foundation.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getCartGraphql = """
query {
  getCart {
    cartId,
    totalPrice,
    itemCount,
    products {
      productId,
      productPrice,
      productName,
      productDesc,
      imageUrl,
    }
  }
}
""";

const getCartIDGraphql = """
  query {
  getCartId
}
""";

const createCartGraphql = """
  mutation 
  createCart {
    cartId,
    totalPrice,
		user {
      userId
    }
  }
""";

const cleanCartGraphql = """
  mutation 
    cleanCart(\$cartId: CartId!) {
      cleanCart(cartId: \$cartId)
    }
""";

const addProductToCart = """
  mutation 
    addProductToCart(\$addToCartInput: AddToCartInput!) {
      addProductToCart(addToCartInput: \$addToCartInput) 
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

  CartItem.fromJson(Map<String, dynamic> json)
      : id = json['productId'].toString(),
        title = json['productName'],
        quantity = 1,
        price = double.parse(json['productPrice'].toString());
}

class CartProvider with ChangeNotifier {
  List<CartItem>? _items = [];

  Future<int> getCartId() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getCartIDGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final cartId = result.data?['getCartId'];
    return cartId;
  }

  void createCart() async {
    MutationOptions queryOptions =
        MutationOptions(document: gql(createCartGraphql));
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
  }

  Future<Cart> getCart() async {
    QueryOptions queryOptions = QueryOptions(
      document: gql(getCartGraphql),
    );
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final cartData = (result.data?["getCart"]);
    final cart = new Cart(
        cartId: cartData["cartId"],
        products: cartData["products"]
            .map<CartItem>((p) => CartItem.fromJson(p))
            .toList(),
        totalPrice: cartData["totalPrice"],
        itemCount: cartData["itemCount"]);
    notifyListeners();
    return cart;
  }

  //counts the amount of entries in the map.
  int get itemCount {
    return _items!.length;
  }

  //counts the total price of the cartItems in the cart.
  double get totalAmount {
    var total = 0.0;
    _items!.forEach((cartItem) {
      total += cartItem.price! * cartItem.quantity!.toDouble();
    });
    return total;
  }

  Future<bool> addItem(int productId, int cartId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(addProductToCart),
        variables: <String, dynamic>{
          "addToCartInput": {
            "cartId": cartId,
            "productId": productId,
          }
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
      return false;
    }
    notifyListeners();
    return true;
    // if (_items!.containsKey(productId)) {
    //   //change quantity...
    //   _items!.update(
    //     productId,
    //     (cartItem) => CartItem(
    //       id: cartItem.id,
    //       title: cartItem.title,
    //       price: cartItem.price,
    //       quantity: cartItem.quantity! + 1,
    //     ),
    //   );
    // } else {
    //   _items!.putIfAbsent(
    //     productId,
    //     () => CartItem(
    //       id: DateTime.now().toString(),
    //       title: title,
    //       price: price,
    //       quantity: 1,
    //     ),
    //   );
    // }
  }

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  Object clearCart(int cartId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(cleanCartGraphql),
        variables: <String, dynamic>{
          "cartId": cartId,
        });
    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    notifyListeners();
    return result;
  }
}
