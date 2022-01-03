import 'package:flutter/material.dart';
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/screens/favorites_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../screens/salad_screen.dart';
import '../screens/sandwich_screen.dart';
import '../screens/lunch_screen.dart';
import '../screens/cart_screen.dart';

class OverviewScreen extends StatefulWidget {
  static final routeName = '/overView';

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Category> categories = [];

  Future<List<Category>> getCategories() async {
    final cat = await Provider.of<CategoryProvider>(context, listen: false)
        .getCategories;
    setState(() {
      categories = cat;
    });

    return categories;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = categories
        .map((c) => Tab(
              text: c.name,
              icon: c.id == "1"
                  ? Icon(Icons.breakfast_dining_outlined)
                  : c.id == "2"
                      ? Icon(Icons.rice_bowl_outlined)
                      : c.id == "3"
                          ? Icon(Icons.lunch_dining_outlined)
                          : null,
            ))
        .toList();
    tabs.add(
        Tab(text: "Favorites", icon: Icon(Icons.favorite_border_outlined)));
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // To get index of current tab use tabController.index
            var index = tabController.index;
            // Your code goes here.
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
              IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
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
