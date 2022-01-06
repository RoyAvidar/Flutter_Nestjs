import "package:flutter/material.dart";
import 'package:flutter_main/models/review.dart';
import 'package:provider/provider.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final review = Provider.of<Review>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Text(review.content!),
    );
  }
}
