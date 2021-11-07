import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  var expireDate;

  Future<bool> get isAuth async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    return _token != null;
  }

  Future<String> get token async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    // if (_expiryDate != null && _expiryDate.isAfter(DateTime.now())) {
    return _token!;
    // }
    // return null;
  }
}
