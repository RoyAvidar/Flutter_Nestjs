import 'package:flutter/material.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/providers/reviews.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:flutter_main/screens/settings/header_settings_screen.dart';
import 'package:flutter_main/screens/splash_screen.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/router.dart';
import 'models/products_provider.dart';

Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Settings.getValue<bool>(HeaderScreen.keyDarkMode, true);
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
        ChangeNotifierProvider(
          create: (ctx) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReviewsProvider(),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, child) => ValueChangeObserver<bool>(
          cacheKey: HeaderScreen.keyDarkMode,
          defaultValue: false,
          builder: (_, isDarkMode, __) => MaterialApp(
            title: 'Lunchies',
            theme: isDarkMode
                ? ThemeData.dark().copyWith(
                    primaryColor: Colors.teal[200],
                    accentColor: Colors.red,
                    scaffoldBackgroundColor: Color(0xFF170635),
                    canvasColor: Color(0xFF170635),
                  )
                : ThemeData.light().copyWith(
                    primaryColor: Colors.blue,
                    accentColor: Colors.lightBlue,
                    appBarTheme: AppBarTheme(color: Colors.black54),
                  ),
            home: SplashScreen(),
            routes: Routes().routers,
          ),
        ),
      ),
    );
  }
}
