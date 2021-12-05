import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/models/product.dart';

class User with ChangeNotifier {
  final int? userId;
  final String? userName;
  String? userPassword;
  final String? userPhone;
  final bool? isAdmin;
  List<Product>? products;
  Order? orders;
  String? userProfilePic;

  User({
    @required this.userId,
    @required this.userName,
    @required this.userPassword,
    @required this.userPhone,
    this.isAdmin,
    @required this.products,
    @required this.orders,
    this.userProfilePic,
  });

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userName = json['userName'],
        userPhone = json['userPhone'],
        isAdmin = json['isAdmin'];
}
