import 'package:flutter/material.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/products_provider.dart';

class SingleProductScreen extends StatefulWidget {
  static const routeName = '/singleProduct';

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  var cart;

  Future<Cart> getCart() async {
    final cartData =
        await Provider.of<CartProvider>(context, listen: false).getCart();
    setState(() {
      cart = new Cart(
          cartId: cartData.cartId,
          products: cartData.products,
          totalPrice: cartData.totalPrice,
          itemCount: cartData.itemCount);
    });
    // print(cart);
    return cart;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCart();
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
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price.toString()}',
            ),
            SizedBox(height: 10),
            Text(
              loadedProduct.description.toString(),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            ElevatedButton(
              onPressed: () {
                print(cart);
                // Provider.of<CartProvider>(context, listen: false)
                //     .addItem(int.parse(productId), cartid);
              },
              child: Text('Add To Cart'),
            )
          ],
        ),
      ),
    );
  }
}
