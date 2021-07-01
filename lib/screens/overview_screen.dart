import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../widgets/product_item.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lunchies'),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
        ),
        children: DUMMY_PRODUCTS
            .map(
              (prodData) => ProductItem(
                prodData.name,
                prodData.description,
                prodData.price,
              ),
            )
            .toList(),
      ),
    );
  }
}
