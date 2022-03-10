import 'package:flutter/material.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatefulWidget {
  //add an image field and change the CircleAvatar to represent it.
  final String id;
  final String productId;
  final String title;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItemWidget(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
  );

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  Cart? cart;
  var isLoading = true;

  Future<Cart?> getCart() async {
    final cartData =
        await Provider.of<CartProvider>(context, listen: false).getCart();
    setState(() {
      cart = cartData;
      isLoading = false;
    });
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
            .removeItem(int.parse(widget.productId), cart!.cartId!);
        // if (widget.quantity <= 0)
        Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
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
              child: FittedBox(
                child: Container(
                  width: 300,
                  height: 300,
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
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "http://10.0.2.2:8000/" + widget.imageUrl.toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text('${widget.title}'),
            subtitle: Text('Price: \$${(widget.price * widget.quantity)}'),
            trailing: Container(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${widget.quantity}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(int.parse(widget.productId), cart!.cartId!);
                      setState(() {
                        widget.quantity = widget.quantity + 1;
                      });
                      ChangeNotifier();
                    },
                    icon: Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.quantity <= 1) {
                        return;
                      }
                      Provider.of<CartProvider>(context, listen: false)
                          .removeItem(
                              int.parse(widget.productId), cart!.cartId!);
                      setState(() {
                        widget.quantity = widget.quantity - 1;
                      });
                      ChangeNotifier();
                    },
                    icon: Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
