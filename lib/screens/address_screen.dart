import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/screens/add_address_screen.dart';
import 'package:flutter_main/widgets/address_item.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);
  static final routeName = '/address';

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
      appBar: AppBar(),
      body: addresses.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'You Have No Addresses Yet.',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 35),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AddAddressScreen.routeName);
                  },
                  child: Text(
                    'Add A New Address',
                    style: TextStyle(
                      color: Colors.green[500],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Pick an Address",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: addresses.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider(
                      create: (c) => addresses[i],
                      child: AddressItem(
                        arrivedFromSettings: false,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AddAddressScreen.routeName);
                  },
                  child: Text(
                    'Add A New Address',
                    style: TextStyle(
                      color: Colors.green[500],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}
