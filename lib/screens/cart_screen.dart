import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show CartProvider;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart';

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
    );
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          //listView of cartItem's ,
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id!,
                cart.items.keys.toList()[i], // this key is the productId.
                cart.items.values.toList()[i].price!,
                cart.items.values.toList()[i].quantity!,
                cart.items.values.toList()[i].title!,
              ),
              itemCount: cart.items.length,
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
                      '\$${cart.totalAmount.toString()}',
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
              Provider.of<OrdersProvider>(context, listen: false).addOrder(
                cart.items.values.toList(),
                cart.totalAmount,
              );
              cart.clearCart();
            },
            style: buttonStyle,
            child: Text('Order Now'),
          ),
        ],
      ),
    );
  }
}
