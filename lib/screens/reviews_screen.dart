import "package:flutter/material.dart";
import 'package:flutter_main/models/review.dart';
import 'package:flutter_main/providers/reviews.dart';
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
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Text("Add a review to this app!"),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(25),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 5 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: reviews.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => reviews[i],
                child: ReviewItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
