import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getUserGraphql = """
  query {
  getSingleUser {
    products {
      productId
      productName,
      productPrice,
      productDesc,
      imageUrl,
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
    _prods = (result.data?["getSingleUser"]["products"]
        .map<Product>((prod) => Product.fromJson(prod)));
    print(_prods);
    notifyListeners();
    return _prods;
  }
}
