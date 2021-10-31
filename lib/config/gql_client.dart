import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLConfig {
  static final HttpLink httpLink = HttpLink("http://10.0.2.2:8000/graphql");

  static final _authLink = AuthLink(getToken: () async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("token");
    return "Bearer $token";
  });

  static Link _link = _authLink.concat(httpLink);

  static final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    defaultPolicies:
        DefaultPolicies(query: Policies(fetch: FetchPolicy.noCache)),
    link: httpLink,
  );

  static final GraphQLClient authClient = GraphQLClient(
    cache: GraphQLCache(),
    defaultPolicies:
        DefaultPolicies(query: Policies(fetch: FetchPolicy.noCache)),
    link: _link,
  );
}
