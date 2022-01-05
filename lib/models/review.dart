import "package:flutter/material.dart";

class Review with ChangeNotifier {
  final int? id;
  final String? content;

  Review({
    @required this.id,
    @required this.content,
  });

  Review.fromJson(Map<String, dynamic> json)
      : id = json['reviewId'],
        content = json['reviewContent'];
}
