import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'product.dart';

const productsGraphql = """
  query {
    products {
      productId,
      productName,
      productPrice,
      productDesc,
      imageUrl,
      category {
        categoryName
      }
    }
}
""";

const createProductGraphql = """
  mutation createProduct(\$createProductInput: CreateProductInput!) {
    createProduct(createProductInput: \$createProductInput) {
      productName
      productPrice
      productDesc
      imageUrl
    }
  }
""";

const updateProductGraphql = """
  mutation updateProduct(\$prodId: prodId!, \$updateProductData: UpdateProductData!) {
    updateProduct(updateProductData: \$updateProductData) {
      productName
      productPrice
      productDesc
      imageUrl
    }
  }
""";

const deleteProductGraphql = """
  mutation deleteProduct(\$deleteProductData: DeleteProductInput!) {
    deleteProduct(deleteProductData: \$deleteProductData) {
      productId
    }
  }
""";

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  Future<List<Product>> get items async {
    QueryOptions queryOptions = QueryOptions(document: gql(productsGraphql));
    QueryResult result = await GraphQLConfig.client.query(queryOptions);
    if (result.hasException) {
      print(result.exception.toString());
    }
    (result.data?['products'] as List).map((prod) => _items.add(prod));
    print(_items);
    notifyListeners();
    return _items;
  }

  // List<Product> get items {
  //   return _items;
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) async {
    String? productName = product.name;
    double? productPrice = product.price;
    String? productDescription = product.description;
    String? productImageUrl = product.imageUrl;
    int? productCategory = product.categoryId;

    MutationOptions queryOptions = MutationOptions(
        document: gql(createProductGraphql),
        variables: <String, dynamic>{
          "createProductInput": {
            "productName": productName,
            "productPrice": productPrice,
            "productDesc": productDescription,
            "imageUrl": productImageUrl,
            "categoryId": productCategory
          }
        });

    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
  }

  void updateProduct(String id, Product newProduct) async {
    String? productName = newProduct.name;
    double? productPrice = newProduct.price;
    String? productDescription = newProduct.description;
    String? productImageUrl = newProduct.imageUrl;
    int? productCategory = newProduct.categoryId;

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      MutationOptions queryOptions = MutationOptions(
          document: gql(updateProductGraphql),
          variables: <String, dynamic>{
            "updateProductData": {
              "productName": productName,
              "productPrice": productPrice,
              "productDesc": productDescription,
              "imageUrl": productImageUrl,
              "categoryId": productCategory
            }
          });
      QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
      if (result.hasException) {
        print(result.exception);
      }
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(String id) async {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    MutationOptions queryOptions = MutationOptions(
        document: gql(deleteProductGraphql),
        variables: <String, dynamic>{
          "deleteProductData": {"productId": id}
        });
    QueryResult result = await GraphQLConfig.client.mutate(queryOptions);

    //go over the _items and see if its the right product.
    if (result.data?['id']) {
      // some code...
      return true;
    }
    notifyListeners();
    return false;
  }
}
