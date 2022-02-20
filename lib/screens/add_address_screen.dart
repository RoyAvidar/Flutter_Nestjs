import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);
  static const routeName = "/add-address";

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _form = GlobalKey<FormState>();
  var _editedAddress = Address(
    addressId: null,
    city: '',
    streetName: '',
    streetNumber: 0,
    floorNumber: 0,
    apartmentNumber: 0,
  );

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    //Provider.of ... addAddress(_editedAddress);
    Provider.of<AddressProvider>(context, listen: false)
        .createAddress(_editedAddress);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Product Added Successfuly!',
          textAlign: TextAlign.left,
        ),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an address"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedAddress = Address(
                    addressId: _editedAddress.addressId,
                    city: value,
                    streetName: _editedAddress.streetName,
                    streetNumber: _editedAddress.streetNumber,
                    floorNumber: _editedAddress.floorNumber,
                    apartmentNumber: _editedAddress.apartmentNumber,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Street'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedAddress = Address(
                    addressId: _editedAddress.addressId,
                    city: _editedAddress.city,
                    streetName: value,
                    streetNumber: _editedAddress.streetNumber,
                    floorNumber: _editedAddress.floorNumber,
                    apartmentNumber: _editedAddress.apartmentNumber,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Street Number'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedAddress = Address(
                    addressId: _editedAddress.addressId,
                    city: _editedAddress.city,
                    streetName: _editedAddress.streetName,
                    streetNumber: int.parse(value!),
                    floorNumber: _editedAddress.floorNumber,
                    apartmentNumber: _editedAddress.apartmentNumber,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Floor'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedAddress = Address(
                    addressId: _editedAddress.addressId,
                    city: _editedAddress.city,
                    streetName: _editedAddress.streetName,
                    streetNumber: _editedAddress.streetNumber,
                    floorNumber: int.parse(value!),
                    apartmentNumber: _editedAddress.apartmentNumber,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apartment Number'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedAddress = Address(
                    addressId: _editedAddress.addressId,
                    city: _editedAddress.city,
                    streetName: _editedAddress.streetName,
                    streetNumber: _editedAddress.streetNumber,
                    floorNumber: _editedAddress.floorNumber,
                    apartmentNumber: int.parse(value!),
                  );
                },
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Save Address:"),
                  IconButton(
                    onPressed: _saveForm,
                    icon: Icon(Icons.save),
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
