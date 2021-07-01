import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String productName;
  final String productDescriptoin;
  final double productPrice;

  const ProductItem(
      this.productName, this.productDescriptoin, this.productPrice);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
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
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: Text(productDescriptoin),
          ),
        ],
      ),
    );
  }
}
