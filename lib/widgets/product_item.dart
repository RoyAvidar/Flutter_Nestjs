import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screens/single_product_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
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
          header: GridTileBar(
            title: Text(
              product.name.toString(),
              textAlign: TextAlign.start,
            ),
            backgroundColor: Colors.black26,
          ),
          footer: GridTileBar(
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
              product.price.toString(),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}
