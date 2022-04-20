import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/providers/cart.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/screens/overview_screen.dart';
// import 'package:flutter_main/widgets/address_item.dart';
// import 'package:flutter_main/widgets/cart_item.dart';
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
    // print(cart!.cartId.toString());
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

  submit() async {
    final cartId =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
    Provider.of<OrdersProvider>(context, listen: false)
        .addOrder(cartId, address!.addressId!);
    final isClean = await Provider.of<CartProvider>(context, listen: false)
        .clearCart(cartId);
    if (isClean) {
      Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
    } else {
      throw new Error();
    }
  }

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Confirmation: ",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Center(
            child: Stack(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 100,
                ),
                Positioned(
                  top: 40,
                  right: 30,
                  child: Icon(
                    Icons.verified_outlined,
                    size: 40,
                  ),
                )
              ],
            ),
          ),
          Text(
            "Thanks for your purchase.",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 50),
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
                                "http://10.0.2.2:8000/" +
                                    cart!.products![i].imageUrl.toString(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text('${cart!.products![i].title}'),
                    subtitle: Text(
                      'Price: \$${(cart!.products![i].price!)}',
                    ),
                    trailing: Text('x ${cart!.products![i].quantity}'),
                  ),
                ),
              ),
            ),
          ),
          //show address and payment method.
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            child: Text('Order Details'),
          ),
          SizedBox(height: 110),
          Container(
            child: TextButton(
              child: Text(
                "Back to main screen",
                style: TextStyle(color: Colors.grey[600]),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(OverviewScreen.routeName);
              },
            ),
          )
        ],
      ),
    );
  }
}
