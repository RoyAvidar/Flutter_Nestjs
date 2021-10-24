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
  mutation {
    createOrder(\$createOrderData: CreateOrderData!) {
      createOrder(createOrderData: \$createOrderData) {
        orderId
      }
    }
  }
""";

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  Future<List<Order>> get getAllOrders async {
    QueryOptions queryOptions = QueryOptions(document: gql(ordersGraphql));
    QueryResult result = await GraphQLConfig.client.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    // (result.data?['orders'] as List).map((order) => _orders.add(order));
    _orders = (result.data?['orders'].map<Order>((ord) => Order.fromJson(ord)))
        .toList();
    print(_orders);
    notifyListeners();
    return _orders;
  }

  //add all the content of the cart into one order.
  void addOrder(
      List<CartItem> cartProducts, double total, String userId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(createOrderGraphql),
        variables: <String, dynamic>{
          "createOrderData": {
            "orderPrice": total,
            "userId": userId,
          }
        });

    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    notifyListeners();
  }

  double get totalAmount {
    return totalAmount;
  }
}
