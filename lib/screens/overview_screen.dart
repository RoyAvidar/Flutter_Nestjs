import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunchies'),
        bottom: TabBar(
          tabs: [
            Tab(
              text: 'Sandwiches',
            ),
            Tab(
              text: 'Salad',
            ),
            Tab(
              text: 'Lunch',
            )
          ],
        ),
      ),
      body: ProductGrid(),
    );
  }
}
