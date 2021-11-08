import 'package:flutter/material.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/auth_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:flutter_main/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
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
            create: (ctx) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ProductsProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => OrdersProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, authData, child) => MaterialApp(
            title: 'Lunchies',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // accentColor: Colors.lightBlue,
              appBarTheme: AppBarTheme(color: Colors.black54),
              fontFamily: 'Lato',
            ),
            darkTheme: ThemeData.dark(),
            //isAuth ? OverviewScreen() : AuthScreen();
            home: SplashScreen(),
            routes: Routes().routers,
          ),
        ));
  }
}
