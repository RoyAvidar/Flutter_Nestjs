import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:provider/provider.dart';

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
    var address;
    Future<Address> getAddresById(addressId) async {
      final addressdb =
          await Provider.of<AddressProvider>(context, listen: false)
              .getAddressByID(addressId);
      setState(() {
        address = addressdb;
      });
      return addressdb;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text(addressId.toString()),
      ),
    );
  }
}
