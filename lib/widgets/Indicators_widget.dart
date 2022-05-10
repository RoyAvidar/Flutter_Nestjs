import 'package:flutter/material.dart';
import 'package:flutter_main/models/product_order.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:provider/provider.dart';

class IndicatorsWidget extends StatefulWidget {
  const IndicatorsWidget({Key? key}) : super(key: key);

  @override
  State<IndicatorsWidget> createState() => _IndicatorsWidgetState();
}

class _IndicatorsWidgetState extends State<IndicatorsWidget> {
  List<ProductOrder> productsFromOrders = [];

  Future<List<ProductOrder>> getProductsFromTheOrders() async {
    final prodOrd = await Provider.of<OrdersProvider>(context, listen: false)
        .getOrderProducts;
    setState(() {
      productsFromOrders = prodOrd;
    });
    return productsFromOrders;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getProductsFromTheOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: productsFromOrders
          .map(
            (data) => Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child:
                  buildIndicator(color: Colors.green, text: data.product!.name),
            ),
          )
          .toList(),
    );
  }

  Widget buildIndicator({
    @required Color? color,
    @required String? text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(height: 10),
          Text(
            text!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}
