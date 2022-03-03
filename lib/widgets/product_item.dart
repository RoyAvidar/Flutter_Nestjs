import 'package:flutter/material.dart';
import 'package:flutter_main/screens/single_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/product.dart';
// import '../screens/single_product_screen.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int cartId = 0;

  Future<int> getCartId() async {
    cartId =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
    if (cartId == 0) {
      throw new Exception("cartId was not found.");
    }
    return cartId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCartId();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );

    return ListTile(
      leading: Hero(
        tag: 'hero',
        child: Stack(
          children: [
            Container(
              width: 65,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 15),
                  )
                ],
                shape: BoxShape.circle,
                image: product.imageUrl == null ||
                        product.imageUrl.toString().isEmpty
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg",
                        ),
                      )
                    : DecorationImage(
                        image: NetworkImage(
                          "http://10.0.2.2:8000/" + product.imageUrl.toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
      ),
      dense: true,
      title: Text(product.name!),
      subtitle: Text(product.price.toString()),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addItem(int.parse(product.id!), cartId);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Item Added To The Cart!',
                      textAlign: TextAlign.left,
                    ),
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeItem(int.parse(product.id!), cartId);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.plus_one),
            ),
            IconButton(
              onPressed: () async {
                final removeItemFuture =
                    await Provider.of<CartProvider>(context, listen: false)
                        .removeItem(int.parse(product.id!), cartId);
                removeItemFuture
                    ?
                    //  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Item Removed From The Cart!',
                            textAlign: TextAlign.left,
                          ),
                          duration: Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem(int.parse(product.id!), cartId);
                            },
                          ),
                        ),
                      )
                    : ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'No ' + product.name! + ' was found in cart',
                            textAlign: TextAlign.left,
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
              },
              icon: Icon(Icons.exposure_minus_1),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(SingleProductScreen.routeName, arguments: product.id);
      },
    );
  }
}
