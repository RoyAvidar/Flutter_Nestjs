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
        title: const Text('Lunchies'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: DUMMY_PRODUCTS
            .map(
              (prodData) => ProductItem(
                prodData.id,
                prodData.name,
                prodData.description,
                prodData.imageUrl,
                prodData.price,
              ),
            )
            .toList(),
      ),
    );
  }
}
