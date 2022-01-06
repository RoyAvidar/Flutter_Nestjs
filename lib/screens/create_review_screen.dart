import "package:flutter/material.dart";
import 'package:flutter_main/providers/reviews.dart';
import 'package:flutter_main/screens/reviews_screen.dart';
import 'package:provider/provider.dart';

class CreateReviewScreen extends StatefulWidget {
  static const routeName = '/create_review';
  const CreateReviewScreen({Key? key}) : super(key: key);

  @override
  _CreateReviewScreenState createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  TextEditingController reviewController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    // TODO: implement dispose
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('What do you think about this app?'),
          Divider(height: 15),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: EdgeInsets.only(left: 25, top: 100, right: 25),
              child: TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  errorText: _validate ? "Please Enter a Review" : null,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Review',
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              setState(() {
                reviewController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
              });
              if (!_validate) {
                Provider.of<ReviewsProvider>(context, listen: false)
                    .postReview(reviewController.text);
                Navigator.of(context)
                    .pushReplacementNamed(ReviewsScreen.routeName);
              }
            },
            child: const Text('Post A Review'),
          ),
        ],
      ),
    );
  }
}
