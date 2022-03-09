import 'package:flutter/cupertino.dart';
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
    cartProducts {
      product {
				productId
      	productPrice,
      	productName,
        imageUrl,
      }
      quantity
    }
  }
}
""";

const getCartIDGraphql = """
  query {
  getCartId
}
""";

const getItemCountGraphql = """
  query {
  getItemCount
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
    cleanCart(\$cartId: Float!) {
      cleanCart(cartId: \$cartId)
    }
""";

const addProductToCart = """
  mutation 
    addProductToCart(\$addToCartInput: AddToCartInput!) {
      addProductToCart(addToCartInput: \$addToCartInput) 
    }
""";

const removeProductFromCart = """
  mutation 
    removeProductFromCart(\$removeFromCartInput: RemoveFromCartInput!) {
      removeProductFromCart(removeFromCartInput: \$removeFromCartInput) 
    }
""";

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;
  final String? imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    this.imageUrl,
  });

  CartItem.fromJson(Map<String, dynamic> json)
      : id = json['product']['productId'].toString(),
        title = json['product']['productName'],
        imageUrl = json['product']['imageUrl'],
        quantity = json['quantity'],
        price = double.parse(json['product']['productPrice'].toString());
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

  Future<Cart> createCart() async {
    MutationOptions queryOptions =
        MutationOptions(document: gql(createCartGraphql));
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final cart = result.data?["createCart"];
    return cart;
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
    final cart = new Cart.fromJson(cartData);
    notifyListeners();
    return cart;
  }

  //counts the amount of entries in the cart.
  Future<int> itemCount() async {
    QueryOptions queryOptions = QueryOptions(
      document: gql(getItemCountGraphql),
    );
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final count = result.data?["getItemCount"];
    notifyListeners();
    return count;
  }

  //counts the total price of the cartItems in the cart.
  // double get totalAmount {
  //   var total = 0.0;
  //   _items!.forEach((cartItem) {
  //     total += cartItem.price! * cartItem.quantity!.toDouble();
  //   });
  //   return total;
  // }

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
  }

  Future<bool> removeItem(int productId, int cartId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(removeProductFromCart),
        variables: <String, dynamic>{
          "removeFromCartInput": {
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
  }

  Future<bool> clearCart(int cartId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(cleanCartGraphql),
        variables: <String, dynamic>{
          "cartId": cartId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isClean = result.data?["cleanCart"];
    notifyListeners();
    return isClean;
  }
}
