import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show CartProvider;
import '../widgets/cart_item.dart';

const submitCartGraphql = """
  mutation {
    submitCartToOrder(\$cartId: int!, \$createOrderInput: CreateOrderInput!) {
      submitCartToOrder(cartId: \$cartId, createOrderInput: \$createOrderInput)
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
  // submit() async {
  //   final cartId = Provider.of<CartProvider>(context, listen: false).cartId;
  //   MutationOptions queryOptions = MutationOptions(document: gql(submitCartGraphql), variables: <String, dynamic>{
  //     "cartId": cartId,
  //     "createOrderInput": {
  //       "userId": ,
  //       "orderPrice": ,
  //     }
  //   });

  //   QueryResult result = await GraphQLConfig.client.mutate(queryOptions);
  //   if (result.hasException) {
  //     print(result.exception);
  //   } else {
  //     Navigator.of(context).pop();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          //listView of cartItem's ,
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id!,
                cart.items.keys.toList()[i], // this key is the productId.
                cart.items.values.toList()[i].price!,
                cart.items.values.toList()[i].quantity!,
                cart.items.values.toList()[i].title!,
              ),
              itemCount: cart.items.length,
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
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              //submit();
            },
            style: buttonStyle,
            child: Text('Order Now'),
          ),
        ],
      ),
    );
  }
}
