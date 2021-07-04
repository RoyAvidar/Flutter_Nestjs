import 'package:flutter/material.dart';

class SingleProductScreen extends StatelessWidget {
  static final routeName = '/singleProduct';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final productName = routeArgs['name'];
    final productDescriptoin = routeArgs['description'];
    // final productImageUrl = routeArgs['imageUrl'];
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Center(
        child: Text(productDescriptoin),
      ),
    );
  }
}
