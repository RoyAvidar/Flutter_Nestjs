import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_main/providers/address_provider.dart';
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData? theme;

  Future<ThemeData?> getThemeData() async {
    final dbThemeData = await Provider.of<UserProvider>(context).theme();
    setState(() {
      theme = dbThemeData;
    });
    return theme;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getThemeData();
  }

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
        ChangeNotifierProvider(
          create: (ctx) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReviewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddressProvider(),
        )
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
          appBarTheme:
              AppBarTheme(backgroundColor: Color.fromARGB(255, 235, 143, 81)),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            headline6: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            bodyText2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Lato',
              fontStyle: FontStyle.italic,
              // color: Colors.red,
            ),
            bodyText1: TextStyle(
              fontSize: 13.0,
              fontFamily: 'Anton',
              fontStyle: FontStyle.italic,
              // color: Colors.black,
            ),
          ),
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 55, 106, 182),
          appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            headline6: TextStyle(
              fontSize: 18.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
            bodyText2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Lato',
              fontStyle: FontStyle.italic,
              // color: Colors.red,
            ),
            bodyText1: TextStyle(
              fontSize: 13.0,
              fontFamily: 'Anton',
              fontStyle: FontStyle.italic,
              // color: Colors.white,
            ),
          ),
        ),
        initial: AdaptiveThemeMode.system,
        builder: (light, dark) => MaterialApp(
          // showPerformanceOverlay: true,
          theme: light,
          darkTheme: dark,
          home: SplashScreen(),
          routes: Routes().routers,
        ),
      ),
    );
  }
}
