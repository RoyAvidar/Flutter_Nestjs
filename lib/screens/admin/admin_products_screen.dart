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
      body: Consumer<ProductsProvider>(
        builder: (co, productsData, ch) => FutureBuilder<List<Product>>(
          future: productsData.items,
          builder: (context, snapshot) {
            List<Widget> children;

            if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else if (snapshot.hasData) {
              if (snapshot.data.toString() == "[]") {
                children = <Widget>[
                  Text(
                    "No items found",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ];
              } else {
                children = <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider(
                        create: (c) => snapshot.data![i],
                        child: AdminProductItem(),
                      ),
                    ),
                  ),
                ];
              }
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}
