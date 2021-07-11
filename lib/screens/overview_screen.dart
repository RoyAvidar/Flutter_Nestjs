import 'package:flutter/material.dart';
import 'package:flutter_main/screens/favorites_screen.dart';
import 'package:flutter_main/screens/lunch_screen.dart';
import 'package:flutter_main/screens/salad_screen.dart';
import 'package:flutter_main/screens/sandwich_screen.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Sandwich'),
  Tab(text: 'Salad'),
  Tab(text: 'Lunch'),
  Tab(text: 'Favorites'),
];

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({Key? key}) : super(key: key);

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
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lunchies'),
            bottom: TabBar(
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: [
              SandwichScreen(),
              SaladScreen(),
              LunchScreen(),
              FavoriteScreen(),
            ],
            // children: tabs.map((Tab tab) {
            //   return Center(
            //     child: Text(
            //       tab.text! + ' Tab',
            //       style: Theme.of(context).textTheme.headline5,
            //     ),
            //   );
            // }).toList(),
          ),
        );
      }),
    );
  }
}
