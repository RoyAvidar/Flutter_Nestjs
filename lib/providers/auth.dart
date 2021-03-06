import 'package:flutter/widgets.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const logoutGraphql = """
  mutation {
    logout
  }
""";

class AuthProvider with ChangeNotifier {
  var expireDate;

  Future<bool> get isAuth async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    return _token != null;
  }

  Future<String> get token async {
    final prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString('token');
    // if (_expiryDate != null && _expiryDate.isAfter(DateTime.now())) {
    return _token!;
    // }
    // return null;
  }

  Future<bool> logout() async {
    MutationOptions queryOptions =
        MutationOptions(document: gql(logoutGraphql));
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    }
    final isLogout = result.data?["logout"];
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return isLogout;
  }
}
