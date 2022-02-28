import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/product.dart';
// import '../screens/single_product_screen.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int cartId = 0;

  Future<int> getCartId() async {
    cartId =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
    if (cartId == 0) {
      throw new Exception("cartId was not found.");
    }
    return cartId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCartId();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );

    // return ListTile(
    //   leading: CircleAvatar(
    //     child: Padding(
    //       padding: EdgeInsets.all(5),
    //       child: FittedBox(
    //         child: Image.network(
    //           "http://10.0.2.2:8000/" + product.imageUrl.toString(),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //   ),
    //   title: Text(product.name!),
    //   subtitle: Text(product.description!),
    //   // dense: true,
    //   // enabled: false,
    //   // selected: true,
    //   // onTap: () {},
    //   trailing: Row(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       IconButton(
    //         onPressed: () {
    //           Provider.of<CartProvider>(context, listen: false)
    //               .addItem(int.parse(product.id!), cartId);
    //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content: Text(
    //                 'Item Added To The Cart!',
    //                 textAlign: TextAlign.left,
    //               ),
    //               duration: Duration(seconds: 1),
    //               action: SnackBarAction(
    //                 label: 'UNDO',
    //                 onPressed: () {
    //                   Provider.of<CartProvider>(context, listen: false)
    //                       .removeItem(int.parse(product.id!), cartId);
    //                 },
    //               ),
    //             ),
    //           );
    //         },
    //         icon: Icon(Icons.add),
    //       ),
    //     ],
    //   ),
    // );
    return ListTile(
      leading: CircleAvatar(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Image.network(
            "http://10.0.2.2:8000/" + product.imageUrl.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(product.name!),
    );
  }
}
