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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Divider(height: 25),
            Text(
              'What do you think about this app?',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: TextField(
                maxLines: null,
                minLines: 2,
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                autofocus: false,
                controller: reviewController,
                decoration: InputDecoration(
                  errorText: _validate ? "Please Write Down a Review" : null,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'My Review',
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
              child: Text(
                'Post A Review',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
