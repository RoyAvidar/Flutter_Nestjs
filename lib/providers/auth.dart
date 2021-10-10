// import 'dart:convert';
// import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/http_exeption.dart';

class AuthProvider with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // String _userId;

  Future<bool> get isAuth async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    return _token != null;
  }

  Future<String> get token async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    return _token!;
  }

//   Future<void> _authenticate(
//       String email, String password, String urlSegment) async {}

//   Future<void> singup(String userName, String password) async {

//   }

//   Future<void> login(String userName, String password) async {

//   }

}
