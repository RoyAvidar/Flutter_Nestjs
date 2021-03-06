import "package:flutter/material.dart";
import 'package:flutter_main/models/user.dart';
import 'package:flutter_main/providers/reviews.dart';

class Review with ChangeNotifier {
  final int? id;
  final String? content;
  final User? userWriter;
  int? isLike;
  int? isDislike;
  List<UserReviewItem>? userReview;
  bool? userDidLikeOrDislike;
  bool? whatUserActuallyDid;

  Review({
    @required this.id,
    @required this.content,
    @required this.userWriter,
    @required this.isLike,
    @required this.isDislike,
    this.userReview,
    this.userDidLikeOrDislike,
    this.whatUserActuallyDid,
  });

  Review.fromJsonWithoutUserReview(Map<String, dynamic> json)
      : id = json['reviewId'],
        content = json['reviewContent'],
        userWriter = User.fromJson(json['user']),
        // userWriter = json['userId'],
        isLike = json['isLike'],
        isDislike = json['isDislike'];

  Review.fromJson(Map<String, dynamic> json)
      : id = json['reviewId'],
        content = json['reviewContent'],
        userWriter = User.fromJson(json['user']),
        isLike = json['isLike'],
        isDislike = json['isDislike'],
        userDidLikeOrDislike = json['userDidLikeOrDislike'],
        whatUserActuallyDid = json['whatUserActuallyDid'],
        userReview = json['userReview']
            .map<UserReviewItem>((ur) => UserReviewItem.fromJson(ur))
            .toList();
}
