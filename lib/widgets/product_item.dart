import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';
import '../providers/cart.dart';
import '../models/product.dart';
import '../screens/single_product_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          SingleProductScreen.routeName,
          arguments: product.id,
        ),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Image.network(
            product.imageUrl.toString(),
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(
                  product.id!,
                  product.price!,
                  product.name!,
                );
                // ScaffoldMessenger.of(context).openDrawer();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added Item To Cart!',
                      textAlign: TextAlign.left,
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      },
                    ),
                  ),
                );
              },
            ),
            trailing: IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
              ),
              onPressed: () {
                product.toggleFavorite();
              },
              color: Theme.of(context).accentColor,
            ),
            backgroundColor: Colors.black54,
            title: Text(
              product.name.toString(),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}
