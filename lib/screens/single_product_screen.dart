import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';

class SingleProductScreen extends StatelessWidget {
  static const routeName = '/singleProduct';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name.toString()),
      ),
      body: Center(
        child: Text(loadedProduct.description.toString()),
      ),
    );
  }
}
