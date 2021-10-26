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

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(
      context,
      listen: false,
    );
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
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
                          order.products![i].id!,
                        ),
                      ],
                    )
                  ],
                ),
                // child: ListView(
                //   children: order.products!
                //       .map(
                //         (prod) => Column(
                //           children: [
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text(
                //                   prod.title!,
                //                   style: TextStyle(
                //                     fontSize: 18,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //                 Text(
                //                   '${prod.quantity}x \$${prod.price}',
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                     color: Colors.grey,
                //                   ),
                //                 )
                //               ],
                //             ),
                //             Divider(),
                //           ],
                //         ),
                //       )
                //       .toList(),
                // ),
              ),
              // ],
            ),
        ],
      ),
    );
  }
}
