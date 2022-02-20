import 'package:flutter/material.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);
  static const routeName = "/confirm-order";

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final addressId = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text(addressId!.toString()),
      ),
    );
  }
}
