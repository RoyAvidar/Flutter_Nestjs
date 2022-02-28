import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:provider/provider.dart';

// import '../models/products_provider.dart';
import '../widgets/product_item.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> products = [];

  Future<List<Product>> getProds() async {
    final prods = await Provider.of<UserProvider>(context, listen: false)
        .getUserProducts();
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
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (c) => products[i],
        child: ProductItem(),
      ),
    );
  }
}
