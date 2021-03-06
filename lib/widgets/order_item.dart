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

    return AnimatedCrossFade(
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime!),
              style: Theme.of(context).textTheme.bodyText2,
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
            onChanged: (value) {},
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
        ],
      ),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime!),
              style: Theme.of(context).textTheme.bodyText2,
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
            onChanged: (value) {},
            activeColor: Colors.green,
            checkColor: Colors.white,
          ),
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
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 15,
          ),
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
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        '${order.products![i].quantity}x \$${order.products![i].price}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Total Amount: ",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                " \$" + order.totalAmount.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          )
        ],
      ),
      crossFadeState:
          _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }
}
