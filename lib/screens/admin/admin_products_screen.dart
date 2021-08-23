import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/products_provider.dart';
import '../../widgets/admin/admin_product_item.dart';
import '../../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class AdminProductsScreen extends StatelessWidget {
  static const routeName = '/admin-products';

  const AdminProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              AdminProductItem(
                productsData.items[i].id!,
                productsData.items[i].name!,
                productsData.items[i].imageUrl!,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
