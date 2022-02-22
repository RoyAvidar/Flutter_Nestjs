import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/screens/add_address_screen.dart';
import 'package:flutter_main/widgets/address_item.dart';
import 'package:provider/provider.dart';

class AccountAddressScreen extends StatefulWidget {
  const AccountAddressScreen({Key? key}) : super(key: key);
  static const routeName = '/account-address';

  @override
  _AccountAddressScreenState createState() => _AccountAddressScreenState();
}

class _AccountAddressScreenState extends State<AccountAddressScreen> {
  List<Address> addresses = [];

  Future<List<Address>> getAddressesByUser() async {
    final addre = await Provider.of<AddressProvider>(context, listen: false)
        .getAddressByUser;
    setState(() {
      addresses = addre;
    });
    return addresses;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAddressesByUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Addresses"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addresses.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: addresses.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider(
                      create: (c) => addresses[i],
                      // child: AddressItem(arrivedFromSettings: true),
                      child: AddressItem(
                        arrivedFromSettings: true,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'You Have No Addresses Yet.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          SizedBox(height: 35),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(AddAddressScreen.routeName);
            },
            child: Text('Add A New Address'),
          ),
        ],
      ),
    );
  }
}
