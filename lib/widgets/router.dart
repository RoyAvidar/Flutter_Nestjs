import 'package:flutter_main/screens/admin/admin_categories_screen.dart';
import 'package:flutter_main/screens/admin/admin_orders_screen.dart';
import 'package:flutter_main/screens/admin/admin_user_screen.dart';
import 'package:flutter_main/screens/overview_screen.dart';
import 'package:flutter_main/screens/settings_screen.dart';

import '../screens/single_product_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/admin/admin_products_screen.dart';
import '../screens/admin/edit_product_screen.dart';

class Routes {
  final routers = {
    AuthScreen.routeName: (ctx) => AuthScreen(),
    SingleProductScreen.routeName: (ctx) => SingleProductScreen(),
    CartScreen.routeName: (ctx) => CartScreen(),
    OrdersScreen.routeName: (ctx) => OrdersScreen(),
    AdminProductsScreen.routeName: (ctx) => AdminProductsScreen(),
    AdminCategoryScreen.routeName: (ctx) => AdminCategoryScreen(),
    AdminOrderScreen.routeName: (ctx) => AdminOrderScreen(),
    AdminUserScreen.routeName: (ctx) => AdminUserScreen(),
    EditProductScreen.routeName: (ctx) => EditProductScreen(),
    OverviewScreen.routeName: (ctx) => OverviewScreen(),
    SettingsScreen.routeName: (ctx) => SettingsScreen()
  };
}
