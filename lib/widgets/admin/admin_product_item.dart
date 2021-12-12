import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:provider/provider.dart';

import '../../screens/admin/edit_product_screen.dart';
import '../../models/products_provider.dart';

class AdminProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    return ListTile(
      title: Text(product.name!),
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage("http://10.0.2.2:8000/" + product.imageUrl!),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: product.id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                //snackBar Product deleted.
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(product.id!);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Product Deleted Successfuly!',
                      textAlign: TextAlign.left,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context)
                    .pushReplacementNamed(OverviewScreen.routeName);
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
