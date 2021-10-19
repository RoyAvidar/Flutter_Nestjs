import 'package:flutter/material.dart';
import 'package:flutter_main/models/order.dart';
import 'package:flutter_main/models/product.dart';

class User with ChangeNotifier {
  final int? userId;
  final String? userName;
  final String? userPassword;
  final String? userPhone;
  final bool? isAdmin;
  final Product? products;
  final Order? orders;

  User({
    @required this.userId,
    @required this.userName,
    @required this.userPassword,
    @required this.userPhone,
    this.isAdmin,
    @required this.products,
    @required this.orders,
  });
}
