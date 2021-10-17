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
  mutation createProduct(\$createProductData: CreateProductData!) {
    createProduct(createProductData: \$createProductData) {
      productName
      productPrice
      productDesc
      imageUrl
      categoryId
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

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: product.name,
      price: product.price,
      description: product.description,
      categoryName: product.categoryName,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
