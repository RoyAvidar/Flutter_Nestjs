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
        await Provider.of<OrdersProvider>(context, listen: false).getAllOrders;
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
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider(
          create: (c) => orders[i],
          child: OrderItem(),
        ),
      ),
    );
  }
}
