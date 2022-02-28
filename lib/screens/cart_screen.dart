import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/screens/address_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:flutter_main/widgets/cart_item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show CartProvider;

const cleanCart = """
  mutation {
  cleanCart(\$cartId: CartId!)
}
""";

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLoading = true;
  Cart? cart;

  Future<Cart?> getCart() async {
    final cartData =
        await Provider.of<CartProvider>(context, listen: false).getCart();
    setState(() {
      cart = cartData;
      isLoading = false;
    });
    return cart;
  }

  Future<bool> cleanCart(int cartId) async {
    final result = await Provider.of<CartProvider>(context, listen: false)
        .clearCart(cartId);
    setState(() {
      cart = new Cart(
        cartId: cartId,
        products: [],
        totalPrice: 0,
        itemCount: 0,
      );
    });
    return result;
  }

  // submit() async {
  //   final cartId =
  //       await Provider.of<CartProvider>(context, listen: false).getCartId();
  //   Provider.of<OrdersProvider>(context, listen: false).addOrder(cartId);
  //   final isClean = await this.cleanCart(cartId);
  //   if (isClean) {
  //     Navigator.of(context).pop();
  //   } else {
  //     throw new Error();
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCart();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cart!.products!.isEmpty
              ? Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Column(
                      children: [
                        Text("No items in cart"),
                        Container(
                          child: TextButton(
                            child: Text("Back to main screen"),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  OverviewScreen.routeName);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // listView of cartItem's ,
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart!.products!.length,
                        itemBuilder: (ctx, i) => CartItemWidget(
                          DateTime.now().toString(),
                          cart!.products![i].id!,
                          cart!.products![i].price!,
                          cart!.products![i].quantity!,
                          cart!.products![i].title!,
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(15),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(fontSize: 15),
                            ),
                            Chip(
                              label: Text(
                                // '\$${cart.totalAmount.toStringAsFixed(2)}',
                                "${cart!.totalPrice}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // submit();
                        Navigator.of(context)
                            .pushNamed(AddressScreen.routeName);
                      },
                      style: buttonStyle,
                      child: Text('Order Now'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        cleanCart(cart!.cartId!);
                      },
                      style: buttonStyle,
                      child: Text('Clear Cart'),
                    ),
                  ],
                ),
    );
  }
}
