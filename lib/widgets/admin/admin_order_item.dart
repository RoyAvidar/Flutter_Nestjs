import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminOrderItem extends StatefulWidget {
  const AdminOrderItem({Key? key}) : super(key: key);

  @override
  _AdminOrderItemState createState() => _AdminOrderItemState();
}

class _AdminOrderItemState extends State<AdminOrderItem> {
  var _expanded = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(
      context,
      listen: false,
    );

    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime!),
          ),
          secondary: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          controlAffinity: ListTileControlAffinity.leading,
          value: order.isReady! ? true : isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
              Provider.of<OrdersProvider>(context, listen: false)
                  .toggleIsReady(int.parse(order.id!));
              print(order.isReady);
            });
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
        if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: min(order.products!.length * 20 + 50, 100),
            // can be a ListView.builder
            child: ListView.builder(
              itemCount: order.products!.length,
              itemBuilder: (ctx, i) => Column(
                children: [
                  Text("total amount: \$" + order.totalAmount.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name:  ${order.products![i].title!}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${order.products![i].quantity}x \$${order.products![i].price}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
