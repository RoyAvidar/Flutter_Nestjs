import '../screens/single_product_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/orders_screen.dart';

class Routes {
  final routers = {
    AuthScreen.routeName: (ctx) => AuthScreen(),
    SingleProductScreen.routeName: (ctx) => SingleProductScreen(),
    CartScreen.routeName: (ctx) => CartScreen(),
    OrdersScreen.routeName: (ctx) => OrdersScreen(),
  };
}
