import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/models/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const getUserProdGraphql = """
  query {
    getUserProducts {
      productId,
      productName,
      productPrice,
      productDesc,
      imageUrl
      category {
        categoryId
      }
    }
  }
""";

const getSingleUser = """
  query {
	getSingleUser {
    userId,
    userName,
    userPhone,
    userProfilePic,
    isAdmin,
    address {
      addressId,
    }
  }
}
""";

const getUserIdGraphql = """
  query {
    getUserId 
  }
""";

const getAllUsers = """
  query {
    users {
      userId
      userName,
      userPhone,
      isAdmin
  }
}
""";

const addProductToUserGraphql = """
  mutation 
    addProductToUser(\$prodId: String!) {
      addProductToUser(prodId: \$prodId)
}
""";

const removeProductFromUser = """
  mutation 
    removeProductFromUser(\$productId: String!) {
      removeProductFromUser(productId: \$productId)
}
""";

const updateUserGraphql = """
  mutation
    updateUser(\$updateUserData: UpdateUserInput!) {
      updateUser(updateUserData: \$updateUserData) {
        userId,
        userName,
        userPhone,
        isAdmin
      }
    }
""";

const changePasswordGraphql = """
  mutation
    changePassword(\$userPassword: String!) {
      changePassword(userPassword: \$userPassword)
  }
""";

const deleteUserGraphql = """
  mutation {
    deleteUser
  }
""";

const getUserDarkModeGraphql = """
  query {
    getUserDarkMode
  }
""";

const toggleUserDarkModeGraphql = """
  mutation {
    toggleUserDarkMode
  }
""";

class UserProvider with ChangeNotifier {
  List<Product> _prods = [];
  List<User> _users = [];

  Future<User> getUser() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getSingleUser));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["getSingleUser"];
    final user = User.fromJson(resultData);
    notifyListeners();
    return user;
  }

  Future<int> getUserId() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserIdGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final userId = result.data?["getUserId"];
    notifyListeners();
    return userId;
  }

  Future<List<User>> getUsers() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getAllUsers));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    _users =
        (result.data?["users"].map<User>((u) => User.fromJson(u))).toList();
    notifyListeners();
    return _users;
  }

  Future<List<Product>> getUserProducts() async {
    QueryOptions queryOptions = QueryOptions(document: gql(getUserProdGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    // print(result.data?["getUserProducts"]);
    // _prods = result.data?["getUserProducts"];
    _prods = (result.data?["getUserProducts"]
        .map<Product>((prod) => Product.fromJson(prod))).toList();
    notifyListeners();
    return _prods;
  }

  Future<bool> addProductToFav(String productId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(addProductToUserGraphql),
        variables: <String, dynamic>{
          "prodId": productId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["addProductToUser"];
    notifyListeners();
    return resultData;
  }

  Future<bool> removeProductFromFav(String productId) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(removeProductFromUser),
        variables: <String, dynamic>{
          "productId": productId,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["removeProductFromUser"];
    notifyListeners();
    return resultData;
  }

  Future<bool> changePassword(String userPassword) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(changePasswordGraphql),
        variables: <String, dynamic>{
          "userPassword": userPassword,
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["changePassword"];
    notifyListeners();
    return resultData;
  }

  Future<bool> deleteUser() async {
    MutationOptions queryOptions =
        MutationOptions(document: gql(deleteUserGraphql));
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["deleteuser"];
    notifyListeners();
    return resultData;
  }

  Future<User> updateUser(String userName, String userPhone) async {
    MutationOptions queryOptions = MutationOptions(
        document: gql(updateUserGraphql),
        variables: <String, dynamic>{
          "updateUserData": {
            "userName": userName,
            "userPhone": userPhone,
          },
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["updateUser"];
    final user = User.fromJson(resultData);
    notifyListeners();
    return user;
  }

  Future<bool> getUserDarkMode() async {
    QueryOptions queryOptions =
        QueryOptions(document: gql(getUserDarkModeGraphql));
    QueryResult result = await GraphQLConfig.authClient.query(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["getUserDarkMode"];
    notifyListeners();
    return resultData;
  }

  Future<bool> toggleUserDarkMode() async {
    MutationOptions queryOptions =
        MutationOptions(document: gql(toggleUserDarkModeGraphql));
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final resultData = result.data?["toggleUserDarkMode"];
    notifyListeners();
    return resultData;
  }

  Future<ThemeData> theme() async {
    final isDarkMode = await getUserDarkMode();
    print(isDarkMode);
    return isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.teal[200],
            accentColor: Colors.red,
            scaffoldBackgroundColor: Color(0xFF170635),
            canvasColor: Color(0xFF170635),
            appBarTheme: AppBarTheme(color: Colors.blueGrey),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            accentColor: Colors.lightBlue,
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.white,
            appBarTheme: AppBarTheme(color: Colors.black54),
          );
  }
}
