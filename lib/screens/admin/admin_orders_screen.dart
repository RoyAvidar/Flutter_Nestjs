import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/widgets/admin/admin_order_item.dart';
import 'package:flutter_main/widgets/app_drawer.dart';
import 'package:flutter_main/widgets/order_item.dart';
import 'package:provider/provider.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-order';

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
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
        title: Text('Hello Admin'),
      ),
      drawer: AppDrawer(),
      body: orders.isEmpty
          ? Center(
              child: Container(
                child: Text(
                  'No Orders Yet.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                Text(
                  "All Orders",
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
                    itemBuilder: (ctx, i) => ChangeNotifierProvider(
                      create: (c) => orders[i],
                      child: AdminOrderItem(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
