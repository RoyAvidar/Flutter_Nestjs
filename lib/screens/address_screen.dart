import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
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
      appBar: AppBar(
        title: Text("My Addresses"),
      ),
      body: addresses.isEmpty
          ? Center(
              child: Container(
                child: Text(
                  'You Have No Addresses Yet.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Pick an Address",
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: addresses.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider(
                      create: (c) => addresses[i],
                      child: AddressItem(),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    backgroundColor: Colors.black26,
                  ),
                  onPressed: () {
                    //navigate to addAddressScreen.
                    // Navigator.of(context).pushNamed(CreateReviewScreen.routeName);
                  },
                  child: Text('Add A Review'),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
    );
  }
}
