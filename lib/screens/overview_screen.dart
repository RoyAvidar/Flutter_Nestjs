import 'package:flutter/material.dart';
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/cart.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:flutter_main/screens/categories_fliter_screen.dart';
import 'package:flutter_main/screens/favorites_screen.dart';
import 'package:flutter_main/widgets/badge.dart';
import 'package:provider/provider.dart';
// import 'package:badges/badges.dart';

import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';

class OverviewScreen extends StatefulWidget {
  static final routeName = '/overView';

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Category> categories = [];
  List<String> _icons = [];

  Future<List<Category>> getCategories() async {
    final cat = await Provider.of<CategoryProvider>(context, listen: false)
        .getCategories;
    setState(() {
      categories = cat;
    });
    return categories;
  }

  List<String> _getIcons() {
    final icons =
        Provider.of<CategoryProvider>(context, listen: false).getIconList;
    setState(() {
      _icons = icons;
    });
    return _icons;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCategories();
    this._getIcons();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = categories.map(
      (c) {
        switch (c.icon) {
          case 'breakfast_dining_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.breakfast_dining_outlined),
              );
            }
          case 'rice_bowl_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.rice_bowl_outlined),
              );
            }
          case 'lunch_dining_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.lunch_dining_outlined),
              );
            }
          case 'local_drink':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.local_drink),
              );
            }
          case 'cake_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.cake_outlined),
              );
            }
          case 'emoji_food_beverage_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.emoji_food_beverage_outlined),
              );
            }
          case 'emoji_people_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.emoji_people_outlined),
              );
            }
          case 'emoji_nature_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.emoji_nature_outlined),
              );
            }
          case 'event_note_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.event_note_outlined),
              );
            }
          case 'fastfood_outlined':
            {
              return Tab(
                text: c.name,
                icon: Icon(Icons.fastfood_outlined),
              );
            }
          default:
            {
              print('error has occurred in tabs');
              return Tab(
                text: c.name,
                icon: Icon(Icons.error),
              );
            }
        }
      },
    ).toList();

    tabs.add(
      Tab(
        text: "Favorites",
        icon: Icon(Icons.favorite_border_outlined),
      ),
    );

    return categories.length == 0
        ? Container()
        : DefaultTabController(
            length: categories.length + 1,
            initialIndex: 0,
            // The Builder widget is used to have a different BuildContext to access
            // closest DefaultTabController.
            child: Builder(
              builder: (BuildContext context) {
                final TabController tabController =
                    DefaultTabController.of(context)!;
                tabController.addListener(
                  () {
                    if (!tabController.indexIsChanging) {
                      // To get index of current tab use tabController.index
                      var index = tabController.index;
                      // Your code goes here.
                    }
                  },
                );
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Shop'),
                    bottom: TabBar(
                      indicatorWeight: 2.5,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(7), // Creates border
                        color: Theme.of(context).primaryColor,
                      ),
                      tabs: tabs,
                    ),
                    actions: [
                      Consumer<CartProvider>(
                        builder: (co, cartData, ch) => FutureBuilder(
                          future: cartData.itemCount(),
                          builder: (context, snapshot) {
                            return Badge(
                              child: IconButton(
                                icon: Icon(Icons.shopping_bag),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(CartScreen.routeName);
                                },
                              ),
                              value: snapshot.data.toString(),
                              color: Colors.amber,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  drawer: AppDrawer(),
                  body: TabBarView(
                    children: [
                      ...categories
                          .map(
                            (cat) => CategoriesFilter(
                              categoryId: int.parse(cat.id!),
                            ),
                          )
                          .toList(),
                      FavoriteScreen(),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
