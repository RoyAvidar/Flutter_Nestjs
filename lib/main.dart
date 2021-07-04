import 'package:flutter/material.dart';
import 'package:flutter_main/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/auth_screen.dart';
import '../screens/overview_screen.dart';
import '../widgets/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Lunchies',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.black,
        ),
        home: OverviewScreen(),
        routes: Routes().routers,
      ),
    );
  }
}
