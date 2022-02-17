import 'package:flutter/material.dart';

class Address with ChangeNotifier {
  final int? addressId;
  final String? city;
  final String? streetName;
  final int? streetNumber;
  final int? floorNumber;
  final int? apartmentNumber;

  Address({
    @required this.addressId,
    @required this.city,
    @required this.streetName,
    @required this.streetNumber,
    @required this.floorNumber,
    @required this.apartmentNumber,
  });
}
