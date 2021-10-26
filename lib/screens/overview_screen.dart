import 'package:flutter/material.dart';
import 'package:flutter_main/screens/favorites_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../screens/salad_screen.dart';
import '../screens/sandwich_screen.dart';
import '../screens/lunch_screen.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Sandwich'),
  Tab(text: 'Salad'),
  Tab(text: 'Lunch'),
  Tab(text: 'Favorites'),
];

class OverviewScreen extends StatefulWidget {
  static final routeName = '/overView';

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
            // var tab = tabController.index;
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lunchies'),
            bottom: TabBar(
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(2), // Creates border
                color: Theme.of(context).accentColor,
              ),
              tabs: tabs,
            ),
            actions: [
              //consumer only rebuilds a part of a widget.
              Consumer<CartProvider>(
                builder: (context, cart, ch) => Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_bag,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: TabBarView(
            children: [
              SandwichScreen(),
              SaladScreen(),
              LunchScreen(),
              FavoriteScreen(),
            ],
          ),
        );
      }),
    );
  }
}
