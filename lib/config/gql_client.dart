import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static final HttpLink httpLink = HttpLink("http://10.0.2.2:8000/graphql");

  static final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    defaultPolicies:
        DefaultPolicies(query: Policies(fetch: FetchPolicy.noCache)),
    link: httpLink,
  );
}
