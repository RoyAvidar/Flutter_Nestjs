import 'package:flutter/material.dart';
import 'package:flutter_main/models/user.dart';

class Address with ChangeNotifier {
  final int? addressId;
  final String? city;
  final String? streetName;
  final int? streetNumber;
  final int? floorNumber;
  final int? apartmentNumber;
  final User? user;

  Address(
      {@required this.addressId,
      @required this.city,
      @required this.streetName,
      @required this.streetNumber,
      @required this.floorNumber,
      @required this.apartmentNumber,
      @required this.user});

  Address.fromJson(Map<String, dynamic> json)
      : addressId = json['addressId'],
        city = json['city'],
        streetName = json['streetName'],
        streetNumber = json['streetNumber'],
        floorNumber = json['floorNumber'],
        apartmentNumber = json['apartmentNumber'],
        user = User.fromJson(json['user']);
}
