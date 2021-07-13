import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
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
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name.toString()),
      ),
      body: Container(
        child: ListView(
          children: [
            Center(
              child: Text(
                loadedProduct.description.toString(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cart.addItem(loadedProduct.id!, loadedProduct.price!,
                    loadedProduct.name!);
              },
              child: Text('Add To Cart'),
            )
          ],
        ),
      ),
    );
  }
}
