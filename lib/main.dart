import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../screens/overview_screen.dart';
import '../widgets/router.dart';
import 'models/products_provider.dart';

// const productsGraphql = """
//   query {
//   products {
//     productId,
//     productName,
//     productPrice,
//     productDesc,
//     imageUrl,
//     category {
//       categoryName
//     }
//   }
// }
// """;

void main() {
  // final HttpLink httpLink = HttpLink("http://localhost:8000/graphql");

  // ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(
  //     link: httpLink,
  //     cache: GraphQLCache(store: InMemoryStore()),
  //   ),
  // );

  // var app = GraphQLProvider(client: client, child: MyApp());

  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter demo',
//       theme: ThemeData(accentColor: Colors.blue),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     Key? key,
//   }) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter demo'),
//       ),
//       body: Query(
//         options: QueryOptions(
//           document: gql(productsGraphql),
//         ),
//         builder: (QueryResult result, {fetchMore, reFetch}) {
//           if (result.hasException) {
//             return Text(result.exception.toString());
//           }

//           if (result.isLoading) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final productList = result.data?['products'];
//           print(productList);

//           return Text("something");
//         },
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
