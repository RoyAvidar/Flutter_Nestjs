import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/products_provider.dart';

class SingleProductScreen extends StatefulWidget {
  static const routeName = '/singleProduct';

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  bool favStatus = false;
  int cartId = 0;
  List<Product> userProds = [];

  Future<int> getCartId() async {
    cartId =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
    if (cartId == 0) {
      throw new Exception("cartId was not found.");
    }
    return cartId;
  }

  Future<List<Product>> getUserProds() async {
    final result = await Provider.of<UserProvider>(context, listen: false)
        .getUserProducts();
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    setState(() {
      userProds = result;
      userProds.forEach((p) {
        if (p.id == productId) {
          favStatus = true;
        } else {
          favStatus = false;
        }
      });
    });
    return userProds;
  }

  void addProductToFav(String prodId) async {
    await Provider.of<UserProvider>(context, listen: false)
        .addProductToFav(prodId);
  }

  void removeProductFromFav(String prodId) async {
    await Provider.of<UserProvider>(context, listen: false)
        .removeProductFromFav(prodId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCartId();
    this.getUserProds();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'dash',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.network(
                    "http://10.0.2.2:8000/" + loadedProduct.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item Description:   '),
                Text(
                  loadedProduct.description.toString(),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item Price:   '),
                Text(
                  '\$${loadedProduct.price.toString()}',
                ),
              ],
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(int.parse(productId), cartId);
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
                            Provider.of<CartProvider>(context, listen: false)
                                .removeItem(int.parse(productId), cartId);
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('Add To Cart'),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () => {
                    favStatus
                        ? setState(() {
                            favStatus = !favStatus;
                            removeProductFromFav(productId);
                          })
                        : setState(() {
                            favStatus = !favStatus;
                            addProductToFav(productId);
                          })
                  },
                  icon: favStatus
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
