import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/overview_screen.dart';
import '../widgets/router.dart';
import 'models/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Lunchies',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.lightBlue[100],
          fontFamily: 'Lato',
        ),
        home: OverviewScreen(),
        routes: Routes().routers,
      ),
    );
  }
}
