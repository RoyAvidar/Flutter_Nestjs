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
        userName,
        userPhone,
        userProfilePic,
        isAdmin
      }
    }
}
""";
const createReviewGraphql = """
  mutation
    createReview(\$createReviewInput: CreateReviewInput!) {
      createReview(createReviewInput: \$createReviewInput) {
        reviewId,
        reviewContent,
        user {
          userId,
          userName,
          userPhone,
          userProfilePic,
          isAdmin
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
    notifyListeners();
    return _reviews;
  }

  Future<Review> postReview(String reviewContent) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(createReviewGraphql),
        variables: <String, dynamic>{
          "createReviewInput": {
            "reviewContent": reviewContent,
          }
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    // print(result.data?["createReview"]);
    final review = Review.fromJson(result.data?["createReview"]);
    notifyListeners();
    return review;
  }
}
