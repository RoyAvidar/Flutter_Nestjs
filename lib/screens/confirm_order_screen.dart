import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/providers/cart.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/widgets/address_item.dart';
import 'package:flutter_main/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);
  static const routeName = "/confirm-order";

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  var isLoading = true;
  var _expanded = false;
  Cart? cart;
  Address? address;

  Future<Cart?> getCart() async {
    final cartData =
        await Provider.of<CartProvider>(context, listen: false).getCart();
    setState(() {
      cart = cartData;
      isLoading = false;
    });
    return cart;
  }

  Future<Address?> getAddress() async {
    final addressId = ModalRoute.of(context)!.settings.arguments as int;
    final addressData =
        await Provider.of<AddressProvider>(context, listen: false)
            .getAddressByID(addressId);
    setState(() {
      address = addressData;
      isLoading = false;
    });
    return address;
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    this.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart!.products!.length,
              itemBuilder: (ctx, i) => Card(
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
                          child: Text('\$${cart!.products![i].price}'),
                        ),
                      ),
                    ),
                    title: Text('${cart!.products![i].title}'),
                    subtitle: Text(
                        'Total: \$${(cart!.products![i].price! * cart!.products![i].quantity!)}'),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.add),
                    //   onPressed: () {},
                    // ),
                    trailing: Text('x ${cart!.products![i].quantity}'),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(address!.city!),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              color: _expanded ? Colors.lightBlue : Colors.grey,
            ),
            trailing: Container(
              width: 50,
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.all(10),
            ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextButton(
              child: Text("Order Now!"),
              onPressed: () {
                //submit(); with dismissable
              },
            ),
          ),
        ],
      ),
    );
  }
}
