import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:provider/provider.dart';

class AddressItem extends StatefulWidget {
  const AddressItem({Key? key}) : super(key: key);

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<Address>(context, listen: false);

    return Column(
      children: [
        ListTile(
          title: Text(address.city! +
              " " +
              address.streetName! +
              " " +
              address.streetNumber.toString()),
          leading: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    //navigate to editAddressScreen & will continue to confirmOrderScreen with editedAddressId.
                    // Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    //     arguments: product.id);
                  },
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  color: Colors.lightGreen,
                  onPressed: () {
                    //will navigate to confirm order screen where submit will use this addressId & cartId.
                    // Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    //     arguments: address.addressId);
                  },
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(address.floorNumber.toString()),
              )
            ],
          )
      ],
    );
  }
}
