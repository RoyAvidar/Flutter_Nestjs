import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/providers/cart.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/screens/overview_screen.dart';
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
    // print(cart);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Order Information: ",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Cart Items: ",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            width: 380,
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: FittedBox(
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
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
                                          cart!.products![i].imageUrl
                                              .toString(),
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
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              "Address Information: ",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          ListTile(
            title: Text("City: " + address!.city!),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              color: _expanded ? Colors.lightBlue : Colors.grey,
            ),
          ),
          if (_expanded)
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Sreet: " + address!.streetName!),
                      Text(
                        "Number: " + address!.streetNumber.toString() + "  ",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Floor: " + address!.floorNumber.toString()),
                      Text(
                          "Apartment:  " + address!.apartmentNumber.toString()),
                    ],
                  )
                ],
              ),
            ),
          Divider(height: 35),
          Text(
            'Total Price: \$${cart!.totalPrice}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 15),
          Dismissible(
            key: ValueKey(cart!.cartId),
            background: Container(
              color: Colors.lightGreen,
              child: Icon(Icons.send),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 15),
            ),
            direction: DismissDirection.startToEnd,
            child: Container(
              // padding: EdgeInsets.only(left: 15),
              width: 360,
              height: 30,
              child: Text(
                "Swipe right to order now!",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            onDismissed: (direction) {
              submit();
            },
          ),
          Container(
            // padding: EdgeInsets.only(left: 10),
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
