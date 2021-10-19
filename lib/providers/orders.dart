import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/order.dart';

import './cart.dart';

const ordersGraphql = """
  query {
  orders {
    orderId,
    orderPrice,
    products {
      productId
    },
    user {
      userId
    }
  }
}
""";

const createOrderGraphql = """
  
""";

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  Future<List<Order>> get getOrders async {
    QueryOptions queryOptions = QueryOptions(document: gql(ordersGraphql));
    QueryResult result = await GraphQLConfig.client.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    (result.data?['orders'] as List).map((order) => _orders.add(order));
    print(_orders);
    notifyListeners();
    return _orders;
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
