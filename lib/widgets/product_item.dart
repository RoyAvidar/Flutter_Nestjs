import 'package:flutter/material.dart';
import '../screens/single_product_screen.dart';

class ProductItem extends StatelessWidget {
  final String productId;
  final String productName;
  final String productDescriptoin;
  final String imageUrl;
  final double productPrice;

  const ProductItem(
    this.productId,
    this.productName,
    this.productDescriptoin,
    this.imageUrl,
    this.productPrice,
  );

  void selectProduct(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      SingleProductScreen.routeName,
      arguments: {
        'id': productId,
        'name': productName,
        'description': productDescriptoin,
        'imageUrl': imageUrl,
        'price': productPrice,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => selectProduct(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Text(productName),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.6),
                Colors.blue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
