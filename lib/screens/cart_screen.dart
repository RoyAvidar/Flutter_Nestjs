import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/widgets/cart_item.dart' as CartWidget;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show CartProvider;
import '../providers/cart.dart' show CartItem;

const submitCartGraphql = """
  mutation {
    submitCartToOrder(\$createOrderInput: CreateOrderInput!) {
      submitCartToOrder(createOrderInput: \$createOrderInput)
    }
  }
""";

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, CartItem> cart = {};

  Future<Map<String, CartItem>> getCart() async {
    final cartId = Provider.of<CartProvider>(context, listen: false).cartId;
    final semiCart =
        await Provider.of<CartProvider>(context, listen: false).getCart(cartId);
    setState(() {
      cart = semiCart;
    });
    return cart;
  }

  submit() async {
    final cartid = Provider.of<CartProvider>(context, listen: false).cartId;
    MutationOptions queryOptions = MutationOptions(
        document: gql(submitCartGraphql),
        variables: <String, dynamic>{
          "createOrderInput": {
            "cartId": cartid,
          }
        });
    QueryResult result = await GraphQLConfig.authClient.mutate(queryOptions);
    if (result.hasException) {
      print(result.exception);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCart();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          // listView of cartItem's ,
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartWidget.CartItem(
                cart.values.toList()[i].id!,
                cart.keys.toList()[i], // this key is the productId.
                cart.values.toList()[i].price!,
                cart.values.toList()[i].quantity!,
                cart.values.toList()[i].title!,
              ),
              itemCount: cart.length,
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 15),
                  ),
                  // Chip(
                  //   label: Text(
                  //     '\$${cart.totalAmount.toStringAsFixed(2)}',
                  //     style: TextStyle(
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              submit();
            },
            style: buttonStyle,
            child: Text('Order Now'),
          ),
        ],
      ),
    );
  }
}
