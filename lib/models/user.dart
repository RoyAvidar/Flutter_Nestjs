import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/models/product.dart';

class User with ChangeNotifier {
  final int? userId;
  final String? userName;
  final String? userLastName;
  final String? userEmail;
  String? userPassword;
  final String? userPhone;
  final bool? isAdmin;
  List<Product>? products;
  Order? orders;
  String? userProfilePic;
  bool? isDarkMode;

  User({
    @required this.userId,
    @required this.userName,
    @required this.userLastName,
    @required this.userEmail,
    @required this.userPassword,
    @required this.userPhone,
    this.isAdmin,
    @required this.products,
    @required this.orders,
    this.userProfilePic,
    this.isDarkMode,
  });

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userName = json['userName'],
        userLastName = json['userLastName'],
        userEmail = json['userEmail'],
        userPhone = json['userPhone'],
        userProfilePic = json['userProfilePic'],
        isAdmin = json['isAdmin'];
}
