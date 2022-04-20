import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/screens/confirm_order_screen.dart';
import 'package:flutter_main/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

class AddressItem extends StatefulWidget {
  const AddressItem({Key? key, this.arrivedFromSettings}) : super(key: key);

  final bool? arrivedFromSettings;

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  var _expanded = false;
  final _formKey = GlobalKey<FormState>();
  var _editedAddress = Address(
    addressId: null,
    city: '',
    streetName: '',
    streetNumber: 0,
    floorNumber: 0,
    apartmentNumber: 0,
  );

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<AddressProvider>(context, listen: false)
        .updateAddress(_editedAddress.addressId!, _editedAddress);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Addess Edited Successfuly!',
          textAlign: TextAlign.left,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
        //CheckboxListTile maybe?
        ListTile(
          title: Text(address.city!),
          subtitle: Text(
            address.streetName! +
                " " +
                address.streetNumber!.toString() +
                ",                      Floor: " +
                address.floorNumber.toString() +
                ", Apartment: " +
                address.apartmentNumber.toString(),
          ),
          isThreeLine: true,
          trailing: Container(
            width: 100,
            child: !isFrom!
                ? IconButton(
                    icon: Icon(Icons.check),
                    color: Colors.lightGreen,
                    onPressed: () {
                      //will navigate to choosePayment screen where submit will use this addressId & cartId.
                      //  Navigator.of(context).pushNamed(
                      //   PaymentScreen.routeName,
                      //   arguments: address.addressId,
                      // );
                      Navigator.of(context).pushNamed(
                          ConfirmOrderScreen.routeName,
                          arguments: address.addressId);
                    },
                  )
                : Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // popup
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  // overflow: Overflow.visible,
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.close),
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          TextFormField(
                                            initialValue: address.city,
                                            decoration: InputDecoration(
                                              labelText: 'City',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide a value.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) {
                                              _editedAddress = Address(
                                                addressId: address.addressId,
                                                city: value,
                                                streetName:
                                                    _editedAddress.streetName,
                                                streetNumber:
                                                    _editedAddress.streetNumber,
                                                floorNumber:
                                                    _editedAddress.floorNumber,
                                                apartmentNumber: _editedAddress
                                                    .apartmentNumber,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: address.streetName,
                                            decoration: InputDecoration(
                                              labelText: 'Street',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide a value.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) {
                                              _editedAddress = Address(
                                                addressId: address.addressId,
                                                city: _editedAddress.city,
                                                streetName: value,
                                                streetNumber:
                                                    _editedAddress.streetNumber,
                                                floorNumber:
                                                    _editedAddress.floorNumber,
                                                apartmentNumber: _editedAddress
                                                    .apartmentNumber,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            initialValue:
                                                address.streetNumber.toString(),
                                            decoration: InputDecoration(
                                              labelText: 'Number',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide a value.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) {
                                              _editedAddress = Address(
                                                addressId: address.addressId,
                                                city: _editedAddress.city,
                                                streetName:
                                                    _editedAddress.streetName,
                                                streetNumber: int.parse(value!),
                                                floorNumber:
                                                    _editedAddress.floorNumber,
                                                apartmentNumber: _editedAddress
                                                    .apartmentNumber,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            initialValue:
                                                address.floorNumber.toString(),
                                            decoration: InputDecoration(
                                              labelText: 'Floor',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide a value.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) {
                                              _editedAddress = Address(
                                                addressId: address.addressId,
                                                city: _editedAddress.city,
                                                streetName:
                                                    _editedAddress.streetName,
                                                streetNumber:
                                                    _editedAddress.streetNumber,
                                                floorNumber: int.parse(value!),
                                                apartmentNumber: _editedAddress
                                                    .apartmentNumber,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: address
                                                .apartmentNumber
                                                .toString(),
                                            decoration: InputDecoration(
                                              labelText: 'Apartment',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please provide a value.';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value) {
                                              _editedAddress = Address(
                                                addressId: address.addressId,
                                                city: _editedAddress.city,
                                                streetName:
                                                    _editedAddress.streetName,
                                                streetNumber:
                                                    _editedAddress.streetNumber,
                                                floorNumber:
                                                    _editedAddress.floorNumber,
                                                apartmentNumber:
                                                    int.parse(value!),
                                              );
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Save Changes"),
                                            onPressed: () {
                                              //save form & edit address.
                                              _saveForm();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.lightBlue,
                      ),
                      IconButton(
                        onPressed: () {
                          //delete this address.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
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
                                    Navigator.of(context)
                                        .pushNamed(SettingsScreen.routeName);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Address Deleted Successfuly!',
                                          textAlign: TextAlign.left,
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Text("Delete Address!"),
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
          ),
        ),
      ],
    );
  }
}
