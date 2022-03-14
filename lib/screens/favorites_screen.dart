import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/providers/user_provider.dart';
import 'package:provider/provider.dart';

// import '../models/products_provider.dart';
import '../widgets/product_item.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<UserProvider>(
      builder: (co, userData, ch) => FutureBuilder<List<Product>>(
        future: userData.getUserProducts(),
        builder: (context, snapshot) {
          List<Widget> children;

          if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else if (snapshot.hasData) {
            if (snapshot.data.toString() == "[]") {
              children = <Widget>[
                Text("No items found"),
              ];
            } else {
              children = <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider(
                      create: (c) => snapshot.data![i],
                      child: ProductItem(),
                    ),
                  ),
                ),
              ];
            }
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
