import 'package:flutter/material.dart';
import '../screens/single_product_screen.dart';

class ProductItem extends StatelessWidget {
  final String productId;
  final String productName;
  final String productDescriptoin;
  final String imageUrl;
  final double productPrice;

  const ProductItem(
    this.productId,
    this.productName,
    this.productDescriptoin,
    this.imageUrl,
    this.productPrice,
  );

  void selectProduct(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      SingleProductScreen.routeName,
      arguments: productId,
      // arguments: {
      //   'id': productId,
      //   'name': productName,
      //   'description': productDescriptoin,
      //   'imageUrl': imageUrl,
      //   'price': productPrice,
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => selectProduct(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          header: GridTileBar(
            title: Text(
              productName,
              textAlign: TextAlign.start,
            ),
          ),
          footer: GridTileBar(
            trailing: IconButton(
              icon: Icon(Icons.favorite_border_outlined),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            backgroundColor: Colors.black54,
            title: Text(
              productPrice.toString(),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}
