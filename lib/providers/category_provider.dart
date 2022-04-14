import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/category.dart';

const categoriesGraphql = """
  query {
  getCategories {
    categoryId,
    categoryName,
    categoryIcon
  }
}
""";

const createCategoryGraphql = """
  mutation
    createCategory(\$createCategoryInput: CreateCategoryInput!) {
      createCategory(createCategoryInput: \$createCategoryInput) {
        categoryName,
        categoryIcon,
      }
    }
""";

const updateCategoryGraphql = """
  mutation 
    updateCategory(\$updateCategoryInput: UpdateCategoryInput!) {
      updateCategory(updateCategoryInput: \$updateCategoryInput)
    }
""";

const deleteCategoryGraphql = """
  mutation
    deleteCategory(\$categoryId: String!) {
      deleteCategory(categoryId: \$categoryId)
    }
""";

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<String> iconList = [
    'local_drink',
    'breakfast_dining_outlined',
    'rice_bowl_outlined',
    'lunch_dining_outlined',
    'cake_outlined',
    'emoji_food_beverage_outlined',
    'emoji_people_outlined',
    'emoji_nature_outlined',
    'event_note_outlined',
    'fastfood_outlined',
  ];

  List<String> get getIconList {
    return iconList;
  }

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

  Future<Category> createCategory(
      String categoryName, String categoryIcon) async {
    MutationOptions queryOptions = MutationOptions(
      document: gql(createCategoryGraphql),
      variables: <String, dynamic>{
        "createCategoryInput": {
          "categoryName": categoryName,
          "categoryIcon": categoryIcon,
        }
      },
    );
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["createCategory"];
    final category = Category.fromJson(resultData);
    notifyListeners();
    return category;
  }

  Future<bool> updateCategory(
      String categoryId, String categoryName, String categoryIcon) async {
    MutationOptions queryoptions = MutationOptions(
      document: gql(updateCategoryGraphql),
      variables: <String, dynamic>{
        "updateCategoryInput": {
          "categoryId": categoryId,
          "categoryName": categoryName,
          "categoryIcon": categoryIcon
        }
      },
    );
    QueryResult result = await GraphQLConfig.authClient.mutate(queryoptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isUpdated = result.data?["updateCategory"];
    return isUpdated;
  }

  Future<bool> deleteCategory(String categoryId) async {
    MutationOptions queryoptions = MutationOptions(
        document: gql(deleteCategoryGraphql),
        variables: <String, dynamic>{
          "categoryId": categoryId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryoptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isDeleted = result.data?["deleteCategory"];
    notifyListeners();
    return isDeleted;
  }
}
