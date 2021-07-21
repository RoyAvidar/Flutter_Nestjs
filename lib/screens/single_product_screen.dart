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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price.toString()}',
            ),
            SizedBox(height: 10),
            Text(
              loadedProduct.description.toString(),
              textAlign: TextAlign.center,
              softWrap: true,
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
