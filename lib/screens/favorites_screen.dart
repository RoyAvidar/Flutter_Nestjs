import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';
import '../widgets/product_item.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = await productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(25),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        // will return a single product as it stored in the products_provider class.
        create: (c) => products[i],
        child: products[i].isFavorite == true ? ProductItem() : Container(),
      ),
    );
  }
}
