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
    createdAt,
    products {
      productId,
      productName,
      productPrice,
      productDesc
    },
    user {
      userId
    }
  }
}
""";

const userOrdersGraphql = """
 query {
 getUserOrders {
    orderId,
    orderPrice,
    createdAt,
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
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _orders = (result.data?['orders'].map<Order>((ord) => Order.fromJson(ord)))
        .toList();
    print(_orders);
    notifyListeners();
    return _orders;
  }

  Future<List<Order>> getUserOrders() async {
    QueryOptions queryOptions = QueryOptions(document: gql(userOrdersGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _orders = (result.data?['orders'].map<Order>((ord) => Order.fromJson(ord)))
        .toList();
    print(_orders);
    notifyListeners();
    return _orders;
  }

  //add all the content of the cart into the order.
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
