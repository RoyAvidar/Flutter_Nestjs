import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/product.dart';
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

class UserProvider with ChangeNotifier {
  List<Product> _prods = [];

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
}
