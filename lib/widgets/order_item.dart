import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
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
          onChanged: (value) {},
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
        if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: min(order.products!.length * 20 + 50, 100),
            child: ListView.builder(
              itemCount: order.products!.length,
              itemBuilder: (ctx, i) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name:  ${order.products![i].title!}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${order.products![i].quantity}x \$${order.products![i].price}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Total Amount: \$" + order.totalAmount.toString(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
