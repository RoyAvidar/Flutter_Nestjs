import "package:flutter/material.dart";
import 'package:flutter_main/models/review.dart';
import 'package:flutter_main/providers/reviews.dart';
import 'package:flutter_main/screens/create_review_screen.dart';
import 'package:flutter_main/widgets/review_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_main/widgets/app_drawer.dart';

class ReviewsScreen extends StatefulWidget {
  static const routeName = '/reviews';
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Review> reviews = [];

  Future<List<Review>> getReviews() async {
    final revs = await Provider.of<ReviewsProvider>(context, listen: false)
        .getAllReviews;
    setState(() {
      reviews = revs;
    });
    return reviews;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                  top: 25, left: 15, right: 15, bottom: 25),
              itemCount: reviews.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => reviews[i],
                //A Review was used after being disposed.
                //You should move your provider above MaterialApp/Navigator.
                //or use ChangeNotifierProvider.value
                child: ReviewItem(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.lightGreen[100],
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CreateReviewScreen.routeName);
                },
                child: const Text('Add A Review'),
              ),
            ],
          ),
          SizedBox(height: 45),
        ],
      ),
    );
  }
}
