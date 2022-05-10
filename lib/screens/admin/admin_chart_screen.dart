import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_main/models/product_order.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/widgets/Indicators_widget.dart';
import 'package:provider/provider.dart';

class AdminChartScreen extends StatefulWidget {
  const AdminChartScreen({Key? key}) : super(key: key);
  static const routeName = '/admin-chart';

  @override
  State<AdminChartScreen> createState() => _AdminChartScreenState();
}

class _AdminChartScreenState extends State<AdminChartScreen> {
  List<ProductOrder> productsFromOrders = [];

  Future<List<ProductOrder>> getProductsFromTheOrders() async {
    final prodOrd = await Provider.of<OrdersProvider>(context, listen: false)
        .getOrderProducts;
    setState(() {
      productsFromOrders = prodOrd;
    });
    return productsFromOrders;
  }

  List<PieChartSectionData> getSections() => productsFromOrders
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final value = PieChartSectionData(
          color: data.product!.id == "1" ? Colors.black : Colors.yellow,
          value: double.parse(data.quantity.toString()),
          title: data.product!.name,
          titleStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        );
        return MapEntry(index, value);
      })
      .values
      .toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getProductsFromTheOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Product Sales Statistics"),
          Expanded(
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: getSections(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: IndicatorsWidget(),
              )
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
