import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/screens/confirm_order_screen.dart';
import 'package:flutter_main/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

class AddressItem extends StatefulWidget {
  const AddressItem({Key? key, this.arrivedFromSettings}) : super(key: key);
  // AddressItem({bool? arrivedFromSettings}) {
  //   this.arrivedFromSettings = arrivedFromSettings;
  // }
  final bool? arrivedFromSettings;

  @override
  _AddressItemState createState() => _AddressItemState();
  // _AddressItemState createState() => _AddressItemState(arrivedFromSettings);
}

class _AddressItemState extends State<AddressItem> {
  var _expanded = false;
  // final bool isFromSettings = arrivedFromSettings;

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<Address>(context, listen: false);
    final isFrom = widget.arrivedFromSettings;

    Future<bool> deleteAddress() async {
      Provider.of<AddressProvider>(context, listen: false)
          .deleteAddress(address.addressId!);
      return true;
    }

    return Column(
      children: [
        ListTile(
          title: Text(address.city!),
          leading: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          ),
          trailing: Container(
            width: 50,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  color: Colors.lightGreen,
                  onPressed: () {
                    //will navigate to confirm order screen where submit will use this addressId & cartId.
                    Navigator.of(context).pushNamed(
                        ConfirmOrderScreen.routeName,
                        arguments: address.addressId);
                  },
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sreet: " + address.streetName!),
                          if (isFrom!)
                            IconButton(
                              onPressed: () {
                                //navigate to editAddressScreen.
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.lightBlue,
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Number: " +
                              address.streetNumber.toString() +
                              "  "),
                          Text("Floor: " + address.floorNumber.toString()),
                          if (isFrom)
                            IconButton(
                              onPressed: () {
                                //delete this address.
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text("Are You Sure?"),
                                    content: Text(
                                        "You will not be able to restore this address!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, "Oops"),
                                        child: Text("Oops"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteAddress();
                                          Navigator.of(context).pushNamed(
                                              SettingsScreen.routeName);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Address Deleted Successfuly!',
                                                textAlign: TextAlign.left,
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: Text("HIT IT!"),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
              ],
            ),
          )
      ],
    );
  }
}
