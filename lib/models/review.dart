import "package:flutter/material.dart";
import 'package:flutter_main/models/user.dart';

class Review with ChangeNotifier {
  final int? id;
  final String? content;
  User? user;

  Review({@required this.id, @required this.content, this.user});

  Review.fromJson(Map<String, dynamic> json)
      : id = json['reviewId'],
        content = json['reviewContent'],
        user = User.fromJson(json['user']);
}
