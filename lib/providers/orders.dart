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
      userId,
      userName,
      userPhone,
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
    products {
      productId,
      productName,
      productPrice,
      productDesc
    },
}
}
""";

const createOrderGraphql = """
  mutation 
    createOrder(\$createOrderData: CreateOrderInput!) {
      createOrder(createOrderData: \$createOrderData) {
        orderId
      }
    }
""";

const toggleIsReadyGraphql = """
  mutation 
    toggleIsReady(\$orderId: Float!) {
      toggleIsReady(orderId: \$orderId)
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
    _orders = (result.data?['orders']
        .map<Order>((ord) => Order.fromJsonWithUser(ord))).toList();
    // print(result.data?['orders']['user']);
    notifyListeners();
    return _orders;
  }

  Future<List<Order>> get getUserOrders async {
    QueryOptions queryOptions = QueryOptions(document: gql(userOrdersGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _orders = (result.data?['getUserOrders']
        .map<Order>((ord) => Order.fromJson(ord))).toList();
    notifyListeners();
    return _orders;
  }

  //add all the content of the cart into the order.
  void addOrder(int cartId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(createOrderGraphql),
        variables: <String, dynamic>{
          "createOrderData": {
            "cartId": cartId,
          }
        });

    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    notifyListeners();
  }

  Future<bool> toggleIsReady(int orderId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(toggleIsReadyGraphql),
        variables: <String, dynamic>{
          "orderId": orderId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isReady = result.data?["toggleIsReady"];
    notifyListeners();
    return isReady;
  }

  double get totalAmount {
    return totalAmount;
  }
}
