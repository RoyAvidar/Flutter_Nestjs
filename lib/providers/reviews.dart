import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/review.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getReviewsGraphql = """
  query {
    getAllReviews {
      reviewId,
      reviewContent,
      user {
        userId,
        userName
      }
    }
}
""";

class ReviewsProvider with ChangeNotifier {
  List<Review> _reviews = [];

  Future<List<Review>> get getAllReviews async {
    QueryOptions queryOptions = QueryOptions(document: gql(getReviewsGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _reviews = result.data?['getAllReviews']
        .map<Review>((rev) => Review.fromJson(rev))
        .toList();
    print(_reviews[0].content);
    notifyListeners();
    return _reviews;
  }
}
