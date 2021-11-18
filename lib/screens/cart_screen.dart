import 'package:flutter/material.dart';
import 'package:flutter_main/config/gql_client.dart';
import 'package:flutter_main/models/cart.dart';
import 'package:flutter_main/widgets/cart_item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show CartProvider;

const submitCartGraphql = """
  mutation 
    submitCartToOrder(\$createOrderInput: CreateOrderInput!) {
      submitCartToOrder(createOrderInput: \$createOrderInput)
    }
  
""";

const cleanCart = """
  mutation {
  cleanCart(\$cartId: CartId!)
}
""";

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLoading = true;
  Cart? cart;

  Future<Cart?> getCart() async {
    final cartData =
        await Provider.of<CartProvider>(context, listen: false).getCart();
    setState(() {
      cart = cartData;
      isLoading = false;
    });
    return cart;
  }

  submit() async {
    final cartid =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
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
      body: isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                // listView of cartItem's ,
                Expanded(
                  child: ListView.builder(
                    itemCount: cart!.products!.length,
                    itemBuilder: (ctx, i) => CartItemWidget(
                      DateTime.now().toString(),
                      cart!.products![i].id!,
                      cart!.products![i].price!,
                      cart!.products![i].quantity!,
                      cart!.products![i].title!,
                    ),
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
                            // '\$${cart.totalAmount.toStringAsFixed(2)}',
                            "${cart!.totalPrice}",
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
