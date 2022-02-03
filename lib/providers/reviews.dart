import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/review.dart';
import 'package:flutter_main/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getReviewsGraphql = """
  query {
    getAllReviews {
    reviewId,
    reviewContent,
    isLike,
    isDislike
    userReview {
      user {
        userId
      }
      review {
        reviewId
      }
    	likeDislike
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

const updateReviewContentGraphql = """
  mutation 
    updateReviewContent(\$updateReviewInput: UpdateReviewInput!) {
      updateReviewContent(updateReviewInput: \$updateReviewInput) {
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

const addReviewLikeGraphql = """
  mutation
    addReviewLike(\$reviewId: Int!) {
      addReviewLike(reviewId: \$reviewId)
    }
""";

const removeReviewLikeGraphql = """
  mutation
    removewReviewLike(\$reviewId: Int!) {
      removeReviewLike(reviewId: \$reviewId)
    }
""";

const addReviewDislikeGraphql = """
  mutation 
    addReviewDislike(\$reviewId: Int!) {
      addReviewDislike(reviewId: \$reviewId)
    }
""";

const removeReviewDislikeGraphql = """
  mutation
    removeReviewDislike(\$reviewId: Int!) {
      removeReviewDislike(reviewId: \$reviewId)
    }
""";

class UserReviewItem {
  final String? id;
  bool? likeDislike;
  final User? user;
  final Review? review;

  UserReviewItem(
      {@required this.id,
      this.likeDislike,
      @required this.user,
      @required this.review});

  UserReviewItem.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        likeDislike = json['likeDislike'],
        user = json['user']['userId'],
        review = json['review']['reviewId'];
}

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

  Future<Review> updateReviewContent(int reviewId, String reviewContent) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(updateReviewContentGraphql),
        variables: <String, dynamic>{
          "updateReviewInput": {
            "reviewId": reviewId,
            "reviewContent": reviewContent,
          }
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final review =
        Review.fromJsonWithoutUserReview(result.data?["updateReviewContent"]);
    notifyListeners();
    return review;
  }

  Future<bool> addReviewLike(int reviewId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(addReviewLikeGraphql),
        variables: <String, dynamic>{
          "reviewId": reviewId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final userDidLike = result.data?["addReviewLike"];
    notifyListeners();
    return userDidLike;
  }

  Future<bool> removeReviewLike(int reviewId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(removeReviewLikeGraphql),
        variables: <String, dynamic>{
          "reviewId": reviewId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final userRemovedLike = result.data?["removeReviewLike"];
    notifyListeners();
    return userRemovedLike;
  }

  Future<bool> addReviewDislike(int reviewId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(addReviewDislikeGraphql),
        variables: <String, dynamic>{
          "reviewId": reviewId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final userDidDislike = result.data?["addReviewDislike"];
    notifyListeners();
    return userDidDislike;
  }

  Future<bool> removeReviewDislike(int reviewId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(removeReviewDislikeGraphql),
        variables: <String, dynamic>{
          "reviewId": reviewId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final userRemoveDislike = result.data?["removeReviewDislike"];
    notifyListeners();
    return userRemoveDislike;
  }
}
