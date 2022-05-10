import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/product_order.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/order.dart';

import './cart.dart';

const ordersGraphql = """
  query {
  orders {
    orderId,
    createdAt,
    orderPrice,
    isReady,
    address,
    user {
      userId,
      userName,
      userPhone
    },
    productOrder {
      quantity,
      product {
        productId,
        productName,
        productPrice,
        productDesc
      }
    }
  }
}
""";

const userOrdersGraphql = """
 query {
 getUserOrders {
    orderId,
    createdAt,
    orderPrice,
    isReady,
    address,
    productOrder {
      quantity,
      product {
        productId,
        productName,
        productPrice,
        productDesc
      }
    }
  }
}
""";

const getSingleOrderGraphql = """
  query
    getSingleOrder(\$getOrderArgs: GetOrderArgs!) {
      getSingleOrder(getOrderArgs: \$getOrderArgs) {
       orderId,
      createdAt,
      orderPrice,
      isReady,
      address,
      productOrder {
      id,
      quantity,
      product {
        productId,
        productName,
        productPrice,
        productDesc,
        imageUrl,
      }
    }
      }
    }
""";

const createOrderGraphql = """
  mutation createOrder(\$createOrderData: CreateOrderInput!) {
      createOrder(createOrderData: \$createOrderData) {
        orderId,
        orderPrice,
        createdAt,
        isReady,
        address,
        productOrder {
        quantity,
        product {
          productId,
          productName,
          productPrice,
          productDesc
        }
      }
  }  
}
""";

const toggleIsReadyGraphql = """
  mutation 
    toggleIsReady(\$orderId: Float!) {
      toggleIsReady(orderId: \$orderId)
    }
""";

const sendConfirmOrderEmailGraphql = """
  query
    sendConfirmOrderEmail(\$orderId: Float!) {
      sendConfirmOrderEmail(orderId: \$orderId)
    }
""";

const getOrderProductsGraphql = """
  query {
    getOrderProducts {
      id,
      order {
        orderId
      },
      product {
        productId
      },
      quantity,
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
    // print(result.data?['getUserOrders']);
    _orders = (result.data?['getUserOrders']
        .map<Order>((ord) => Order.fromJson(ord))).toList();
    notifyListeners();
    return _orders;
  }

  Future<Order> getOrderById(int orderId) async {
    QueryOptions queryOptions = QueryOptions(
      document: gql(getSingleOrderGraphql),
      variables: <String, dynamic>{
        "getOrderArgs": {
          "orderId": orderId,
        }
      },
    );
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final order = Order.fromJson(result.data?['getSingleOrder']);
    notifyListeners();
    return order;
  }

  //add all the content of the cart into the order.
  Future<Order> addOrder(int cartId, int addressId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(createOrderGraphql),
        variables: <String, dynamic>{
          "createOrderData": {
            "cartId": cartId,
            "addressId": addressId,
          }
        });

    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    // print(result.data?['createOrder']);
    final ord = result.data?['createOrder'];
    final order = Order.fromJson(ord);
    notifyListeners();
    return order;
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

  Future<bool> sendConfirmOrderEmail(int orderId) async {
    QueryOptions queryOptions = QueryOptions(
        document: gql(sendConfirmOrderEmailGraphql),
        variables: <String, dynamic>{
          "orderId": orderId,
        });
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final emailSent = result.data?['sendConfirmOrderEmail'];
    notifyListeners();
    return emailSent;
  }

  Future<List<ProductOrder>> get getOrderProducts async {
    QueryOptions queryOptions =
        QueryOptions(document: gql(getOrderProductsGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final orderProducts = result.data?['getOrderProducts']
        .map<ProductOrder>((ordProd) => ProductOrder.fromJson(ordProd))
        .toList();
    notifyListeners();
    return orderProducts;
  }
}
