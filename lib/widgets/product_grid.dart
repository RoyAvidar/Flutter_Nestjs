import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(25),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: DUMMY_PRODUCTS.length,
      itemBuilder: (ctx, i) => ProductItem(
        DUMMY_PRODUCTS[i].id ?? '',
        DUMMY_PRODUCTS[i].name ?? '',
        DUMMY_PRODUCTS[i].description ?? '',
        DUMMY_PRODUCTS[i].imageUrl ?? '',
        DUMMY_PRODUCTS[i].price ?? 0,
      ),
    );
  }
}
