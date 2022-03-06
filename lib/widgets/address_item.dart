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
        ListTile(
          title: Text(address.city!),
          leading: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            color: _expanded ? Colors.black : Theme.of(context).primaryColor,
          ),
          trailing: Container(
            width: 50,
            child: Row(
              children: [
                if (!isFrom!)
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
                          Text(
                            "Number: " + address.streetNumber.toString() + "  ",
                          ),
                          if (isFrom)
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
                                                      addressId:
                                                          address.addressId,
                                                      city: value,
                                                      streetName: _editedAddress
                                                          .streetName,
                                                      streetNumber:
                                                          _editedAddress
                                                              .streetNumber,
                                                      floorNumber:
                                                          _editedAddress
                                                              .floorNumber,
                                                      apartmentNumber:
                                                          _editedAddress
                                                              .apartmentNumber,
                                                    );
                                                  },
                                                ),
                                                TextFormField(
                                                  initialValue:
                                                      address.streetName,
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
                                                      addressId:
                                                          address.addressId,
                                                      city: _editedAddress.city,
                                                      streetName: value,
                                                      streetNumber:
                                                          _editedAddress
                                                              .streetNumber,
                                                      floorNumber:
                                                          _editedAddress
                                                              .floorNumber,
                                                      apartmentNumber:
                                                          _editedAddress
                                                              .apartmentNumber,
                                                    );
                                                  },
                                                ),
                                                TextFormField(
                                                  initialValue: address
                                                      .streetNumber
                                                      .toString(),
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
                                                      addressId:
                                                          address.addressId,
                                                      city: _editedAddress.city,
                                                      streetName: _editedAddress
                                                          .streetName,
                                                      streetNumber:
                                                          int.parse(value!),
                                                      floorNumber:
                                                          _editedAddress
                                                              .floorNumber,
                                                      apartmentNumber:
                                                          _editedAddress
                                                              .apartmentNumber,
                                                    );
                                                  },
                                                ),
                                                TextFormField(
                                                  initialValue: address
                                                      .floorNumber
                                                      .toString(),
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
                                                      addressId:
                                                          address.addressId,
                                                      city: _editedAddress.city,
                                                      streetName: _editedAddress
                                                          .streetName,
                                                      streetNumber:
                                                          _editedAddress
                                                              .streetNumber,
                                                      floorNumber:
                                                          int.parse(value!),
                                                      apartmentNumber:
                                                          _editedAddress
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
                                                      addressId:
                                                          address.addressId,
                                                      city: _editedAddress.city,
                                                      streetName: _editedAddress
                                                          .streetName,
                                                      streetNumber:
                                                          _editedAddress
                                                              .streetNumber,
                                                      floorNumber:
                                                          _editedAddress
                                                              .floorNumber,
                                                      apartmentNumber:
                                                          int.parse(value!),
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Submit"),
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Floor: " + address.floorNumber.toString()),
                          Text("Apartment:  " +
                              address.apartmentNumber.toString()),
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
