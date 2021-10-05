import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../screens/overview_screen.dart';
import '../widgets/router.dart';
import 'models/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //connection to the server.
    // final HttpLink link = HttpLink(uri: "http://10.0.2.2:4000/");

    // ValueNotifier<GraphQLClient> client =
    //     ValueNotifier(GraphQLClient(cache: InMemoryCache(), link: link));
    //return GraphQLProvider(
    // client: client,
    //  home: ...,
    // )

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Lunchies',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.lightBlue[200],
          fontFamily: 'Lato',
        ),
        home: OverviewScreen(),
        routes: Routes().routers,
      ),
    );
  }
}
