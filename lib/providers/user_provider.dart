import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getUserGraphql = """
  query {
    getUserProducts {
      productId,
      productName,
      productPrice,
      productDesc,
      imageUrl
      category {
        categoryId
      }
    }
  }
""";

const getAllUsers = """
  query {
    users {
      userId
      userName,
      userPhone,
      isAdmin
  }
}
""";

const addProductToUserGraphql = """
  mutation 
    addProductToUser(\$prodId: String!) {
      addProductToUser(prodId: \$prodId)
}
""";

const removeProductFromUser = """
  mutation 
    removeProductFromUser(\$productId: String!) {
      removeProductFromUser(productId: \$productId)
}
""";

class UserProvider with ChangeNotifier {
  List<Product> _prods = [];
  List<User> _users = [];

  Future<List<User>> getUsers() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getAllUsers));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _users = result.data?["users"];
    notifyListeners();
    return _users;
  }

  Future<List<Product>> getUserProducts() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    // print(result.data?["getUserProducts"]);
    // _prods = result.data?["getUserProducts"];
    _prods = (result.data?["getUserProducts"]
        .map<Product>((prod) => Product.fromJson(prod))).toList();
    notifyListeners();
    return _prods;
  }

  Future<bool> addProductToFav(String productId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(addProductToUserGraphql),
        variables: <String, dynamic>{
          "prodId": productId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["addProductToUser"];
    return resultData;
  }

  Future<bool> removeProductFromFav(String productId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(removeProductFromUser),
        variables: <String, dynamic>{
          "productId": productId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["removeProductFromUser"];
    return resultData;
  }
}
