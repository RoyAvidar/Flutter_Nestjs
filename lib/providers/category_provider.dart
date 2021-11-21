import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/category.dart';

const categoriesGraphql = """
  query {
  getCategories {
    categoryId,
    categoryName
  }
}
""";

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  Future<List<Category>> get getCategories async {
    QueryOptions queryOptions = QueryOptions(document: gql(categoriesGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _categories = (result.data?["getCategories"]
        .map<Category>((cat) => Category.fromJson(cat))).toList();
    // print(_categories);
    notifyListeners();
    return _categories;
  }
}