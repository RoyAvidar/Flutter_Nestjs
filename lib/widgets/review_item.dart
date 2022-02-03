import "package:flutter/material.dart";
import 'package:flutter_main/models/review.dart';
import 'package:provider/provider.dart';

class ReviewItem extends StatefulWidget {
  const ReviewItem({Key? key}) : super(key: key);

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final review = Provider.of<Review>(context, listen: false);
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
            width: 150,
            child: Row(
              children: [
                Text(
                  "Written by: -- " + review.userWriter!.userName!,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                  ),
                ),
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
          contentPadding: EdgeInsets.all(5),
        ),
        if (_expanded)
          Container(
            child: Text(
              review.content!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
            ),
          ),
      ],
    );
  }
}
