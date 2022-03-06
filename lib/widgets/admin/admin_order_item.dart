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
      crossAxisAlignment: CrossAxisAlignment.start,
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
            color: _expanded ? Colors.black : Theme.of(context).primaryColor,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          value: order.isReady! ? true : isChecked,
          onChanged: (value) {
            Provider.of<OrdersProvider>(context, listen: false)
                .toggleIsReady(int.parse(order.id!));
            setState(() {
              order.isReady = true;
            });
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
        if (_expanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address Info: ",
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.values[3],
                ),
              ),
              SizedBox(height: 10),
              Text(
                order.address!,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.values[4],
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Cart Info: ",
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.values[3],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                height: min(order.products!.length * 20 + 20, 100),
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
                              fontSize: 14,
                              // color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.values[4],
                            ),
                          ),
                          Text(
                            '${order.products![i].quantity}x \$${order.products![i].price}',
                            style: TextStyle(
                              fontSize: 14,
                              // color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.values[4],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              Text(
                "User Info: ",
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.values[3],
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Name:  " + order.user!.userName!,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.values[4],
                ),
              ),
              Text(
                "Phone:  " + order.user!.userPhone!,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.values[4],
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Total Amount: \$" + order.totalAmount.toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.values[3],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
