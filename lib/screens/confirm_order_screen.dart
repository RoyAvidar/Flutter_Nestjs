import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:provider/provider.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);
  static const routeName = "/confirm-order";

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  var isLoading = true;
  Order? order;

  Future<Order> getOrder() async {
    final orderId = ModalRoute.of(context)!.settings.arguments as int;
    final orderData = await Provider.of<OrdersProvider>(context, listen: false)
        .getOrderById(orderId);
    setState(() {
      order = orderData;
      isLoading = false;
    });
    return order!;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    this.getOrder();
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
            "Thank you for your purchase.",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "Your order will reach you soon!",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 50),
          order == null
              ? Text('Error: no order was found.')
              : Expanded(
                  child: ListView.builder(
                    itemCount: order!.products!.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: FittedBox(
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(0, 15),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "http://10.0.2.2:8000/" +
                                        order!.products![i].imageUrl.toString(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(order!.products![i].title!),
                        subtitle: Text(order!.products![i].price!.toString()),
                        trailing: Text('x ${order!.products![i].quantity}'),
                      ),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Total Price: ",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              order == null
                  ? Text("data")
                  : Text(
                      "\$" + order!.totalAmount.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
            ],
          ),
          Divider(height: 5),
          //show address and payment method.
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(child: Text("Order  #" + order!.id!)),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          order!.address!,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Divider(
                          height: 10,
                          color: Colors.grey,
                        ),
                        Text(
                          "Created at: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Text(
                          order!.dateTime.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Divider(
                          height: 10,
                          color: Colors.grey,
                        ),
                        Text(
                          "Paymet Method: ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    actions: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "cancel",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            child: Text('Order Details'),
          ),
          order == null ? Text("Order #" + order!.id!) : Container(),
          SizedBox(height: 110),
          Container(
            child: ElevatedButton(
              child: Text(
                "Back to main screen",
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
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
