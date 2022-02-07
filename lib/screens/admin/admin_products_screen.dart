import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:provider/provider.dart';

import '../../models/products_provider.dart';
import '../../widgets/admin/admin_product_item.dart';
import '../../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  static const routeName = '/admin-products';

  const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //... navigate to the add product screen.
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: null);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      //can use consumer here, insted of provider.
      body: Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => products[i],
                child: AdminProductItem(),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: null);
            },
            child: const Text('Add A Product'),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
