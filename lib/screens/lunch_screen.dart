import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../models/products_provider.dart';

class LunchScreen extends StatefulWidget {
  @override
  State<LunchScreen> createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  List<Product> products = [];

  Future<List<Product>> getProds() async {
    final prods =
        await Provider.of<ProductsProvider>(context, listen: false).items;
    setState(() {
      products = prods;
    });
    return products;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getProds();
  }

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
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        // will return a single product as it stored in the products_provider class.
        create: (c) => products[i],
        child: products[i].categoryId == 2 ? ProductItem() : Container(),
      ),
    );
  }
}
