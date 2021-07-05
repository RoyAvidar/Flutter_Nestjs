import 'package:flutter/material.dart';

class SingleProductScreen extends StatelessWidget {
  static const routeName = '/singleProduct';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    // final productName = routeArgs['name'];
    // final productDescriptoin = routeArgs['description'];
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Center(
        child: Text('description'),
      ),
    );
  }
}
