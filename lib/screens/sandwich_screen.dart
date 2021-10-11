import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../models/products_provider.dart';
// import '../widgets/product_grid.dart';

class SandwichScreen extends StatefulWidget {
  @override
  State<SandwichScreen> createState() => _SandwichScreenState();
}

class _SandwichScreenState extends State<SandwichScreen> {
  @override
  Future<List<Product>> initState() async {
    super.initState();
    final products = await Provider.of<ProductsProvider>(context).items;
    return products;
  }

  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //   padding: const EdgeInsets.all(25),
    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: 200,
    //     childAspectRatio: 3 / 2,
    //     crossAxisSpacing: 20,
    //     mainAxisSpacing: 20,
    //   ),
    //   itemCount: products.length,
    //   itemBuilder: (ctx, i) => ChangeNotifierProvider(
    //     // will return a single product as it stored in the products_provider class.
    //     create: (c) => products[i],
    //     child: products[i].categoryName == 'Sandwich'
    //         ? ProductItem()
    //         : Container(),
    //   ),
    // );
    return Text("");
  }
}
