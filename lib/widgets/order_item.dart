import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import 'package:provider/provider.dart';

class OrderItem extends StatefulWidget {
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(
      context,
      listen: false,
    );
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      if (isChecked) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
                if (order.isReady == false) {
                  Provider.of<OrdersProvider>(context, listen: false)
                      .toggleIsReady(int.parse(order.id!));
                  print('hj');
                }
              });
            },
          ),
          ListTile(
            title: Text('Total:  \$${order.totalAmount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime!),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
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
      ),
    );
  }
}
