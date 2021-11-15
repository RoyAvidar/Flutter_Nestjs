import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatefulWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemWidget(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int? cartId;

  getCartId() async {
    final Id =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
    setState(() {
      cartId = Id;
    });
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
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //bool future.
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeItem(int.parse(widget.productId), cartId!);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${widget.price}'),
                ),
              ),
            ),
            title: Text('${widget.title}'),
            subtitle: Text('Total: \$${(widget.price * widget.quantity)}'),
            // trailing: IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: () {},
            // ),
            trailing: Text('x ${widget.quantity}'),
          ),
        ),
      ),
    );
  }
}
