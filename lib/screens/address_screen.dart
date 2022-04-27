import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/screens/add_address_screen.dart';
import 'package:flutter_main/screens/payment_screen.dart';
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
  int? selectedAddressId;

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
                  "Shipping",
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
                      child: CheckboxListTile(
                        dense: true,
                        title: Text(
                          addresses[i].city! +
                              ', ' +
                              addresses[i].streetName! +
                              ' ' +
                              addresses[i].streetNumber.toString(),
                        ),
                        subtitle: Text(
                          'Floor:' +
                              addresses[i].floorNumber.toString() +
                              ', Apartment:' +
                              addresses[i].apartmentNumber.toString(),
                        ),
                        secondary: Icon(Icons.cabin),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        checkColor: Colors.black,
                        value: selectedAddressId == addresses[i].addressId,
                        onChanged: (value) {
                          if (value!) {
                            setState(() {
                              selectedAddressId = addresses[i].addressId;
                            });
                          } else {
                            setState(() {
                              selectedAddressId = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                //should give the address id to the PaymentScreen for later useage.
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: Text('Choose Payment Method'),
                  onPressed: selectedAddressId != null
                      ? () {
                          Navigator.of(context).pushNamed(
                            PaymentScreen.routeName,
                            arguments: selectedAddressId,
                          );
                        }
                      : () {},
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
