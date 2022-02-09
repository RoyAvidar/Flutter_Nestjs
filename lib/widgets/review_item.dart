import "package:flutter/material.dart";
import 'package:flutter_main/models/review.dart';
import 'package:flutter_main/models/user.dart';
import 'package:flutter_main/providers/reviews.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ReviewItem extends StatefulWidget {
  const ReviewItem({Key? key}) : super(key: key);

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  int userId = 0;
  var _expanded = false;

  Future<int> getUserId() async {
    userId =
        await Provider.of<UserProvider>(context, listen: false).getUserId();
    if (userId == 0) {
      throw new Exception("cartId was not found.");
    }
    return userId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    final review = Provider.of<Review>(context, listen: false);
    // final user = Provider.of<User>(context, listen: false);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: review.userWriter!.userProfilePic!.isNotEmpty
                ? NetworkImage(
                    "http://10.0.2.2:8000/" +
                        review.userWriter!.userProfilePic!,
                  )
                : NetworkImage(
                    'https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg',
                  ),
          ),
          trailing: Container(
            // color: Colors.grey,
            width: 125,
            child: Row(
              children: [
                Text("Review #:  " + review.id.toString()),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  color:
                      _expanded ? Colors.red : Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          minVerticalPadding: 15,
          contentPadding: EdgeInsets.all(15),
        ),
        if (_expanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  review.content!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                ),
              ),
              SizedBox(height: 7),
              review.userWriter!.userId != userId
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: review.userDidLikeOrDislike!
                              ? () {
                                  if (review.whatUserActuallyDid == true) {
                                    Provider.of<ReviewsProvider>(context,
                                            listen: false)
                                        .removeReviewLike(review.id!);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Like Removed',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              : () {
                                  Provider.of<ReviewsProvider>(context,
                                          listen: false)
                                      .addReviewLike(review.id!);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Like Added',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          icon: Icon(Icons.favorite),
                          color: Colors.green,
                        ),
                        IconButton(
                          onPressed: review.userDidLikeOrDislike!
                              ? () {
                                  if (review.whatUserActuallyDid == false) {
                                    Provider.of<ReviewsProvider>(context,
                                            listen: false)
                                        .removeReviewDislike(review.id!);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Disike Removed',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              : () {
                                  Provider.of<ReviewsProvider>(context,
                                          listen: false)
                                      .addReviewDislike(review.id!);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Dislike Added',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          icon: Icon(Icons.broken_image_outlined),
                          color: Colors.red,
                        ),
                      ],
                    )
                  : SizedBox(height: 7),
              Row(
                children: [
                  //should be a IconButton that renders showDialog&ListView.builder with userReview data and filter the likeDislke for true/false
                  Text("Likes:  " + review.isLike.toString() + " | "),
                  Text("Dislikes:  " + review.isDislike.toString()),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Written by: -- " + review.userWriter!.userName!,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
