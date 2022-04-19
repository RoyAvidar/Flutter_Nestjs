import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show OrdersProvider;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];

  Future<List<Order>> getOrders() async {
    final ord =
        await Provider.of<OrdersProvider>(context, listen: false).getUserOrders;
    setState(() {
      orders = ord;
    });
    return orders;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: orders.isEmpty
          ? Center(
              child: Container(
                child: Text(
                  'You Have No Orders Yet.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
          : Column(
              children: [
                Text(
                  "My Orders",
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: orders[i],
                      child: OrderItem(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
