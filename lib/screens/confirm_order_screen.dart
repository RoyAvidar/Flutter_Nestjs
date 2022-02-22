import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/providers/cart.dart';
import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);
  static const routeName = "/confirm-order";

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCart();
  }

  @override
  Widget build(BuildContext context) {
    final addressId = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
          // child: ListView(
          //   children: [
          //     ListTile(
          //       leading: Text(addressId.toString()),
          //       trailing: Text(cart!.cartId.toString()),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
