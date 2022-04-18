// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'product.dart';

const productsGraphql = """
  query {
    products {
      productId,
      productName,
      productPrice,
      productDesc,
      imageUrl,
      
    }
}
""";

const productsByCategoryGraphql = """
  query 
    getProductsByCategory(\$categoryId: Float!) {
      getProductsByCategory(categoryId: \$categoryId) {
        productId,
        productName,
        productPrice,
        productDesc,
        imageUrl,
        category {
        categoryId
       }
      }
    }
""";

const createProductGraphql = """
  mutation createProduct(\$createProductInput: CreateProductInput!, \$file: Upload!) {
    createProduct(createProductInput: \$createProductInput, file: \$file) {
      productId,
      productName,
      productPrice,
      productDesc,
      imageUrl,
      category {
        categoryId
      }
    }
  }
""";

const updateProductGraphql = """
  mutation updateProduct(\$updateProductData: UpdateProductInput!, \$prodId: Float!) {
    updateProduct(updateProductData: \$updateProductData, prodId: \$prodId) {
      productId,
      productName,
      productPrice,
      productDesc,
      imageUrl,
      category {
        categoryId
      }
    }
  }
""";

const deleteProductGraphql = """
  mutation deleteProduct(\$deleteProductData: DeleteProductInput!) {
    deleteProduct(deleteProductData: \$deleteProductData) 
  }
""";

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  Future<List<Product>> get items async {
    QueryOptions queryOptions = QueryOptions(document: gql(productsGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception.toString());
    }
    _items = (result.data?['products'].map<Product>((p) => Product.fromJson(p)))
        .toList();
    notifyListeners();
    return _items;
  }

  Future<List<Product>> getProductByCategory(int categoryId) async {
    QueryOptions queryOptions = QueryOptions(
        document: gql(productsByCategoryGraphql),
        variables: <String, dynamic>{
          "categoryId": categoryId,
        });
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _items = (result.data?['getProductsByCategory']
        .map<Product>((p) => Product.fromJson(p))).toList();
    notifyListeners();
    return _items;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<Product> addProduct(
      Product product, MultipartFile productImageUrl) async {
    String? productName = product.name;
    double? productPrice = product.price;
    String? productDescription = product.description;
    int? productCategory = product.categoryId;

    MutationOptions queryOptions = MutationOptions(
        document: gql(createProductGraphql),
        variables: <String, dynamic>{
          "createProductInput": {
            "productName": productName,
            "productPrice": productPrice,
            "productDesc": productDescription,
            "categoryId": productCategory
          },
          "file": productImageUrl,
        });

    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["createProduct"];
    final prod = Product.fromJson(resultData);
    notifyListeners();
    return prod;
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
            "prodId": int.parse(id),
            "updateProductData": {
              "productName": productName,
              "productPrice": productPrice,
              "productDesc": productDescription,
              "imageUrl": productImageUrl,
              "categoryId": productCategory
            }
          });
      QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
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
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    final isDeleted = result.data?["deleteProduct"];
    notifyListeners();
    return isDeleted;
  }
}
