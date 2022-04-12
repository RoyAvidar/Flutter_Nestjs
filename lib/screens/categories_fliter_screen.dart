import 'package:flutter/material.dart';
import 'package:flutter_main/models/product.dart';
import 'package:flutter_main/models/products_provider.dart';
import 'package:flutter_main/widgets/product_item.dart';
import 'package:provider/provider.dart';

class CategoriesFilter extends StatefulWidget {
  const CategoriesFilter({Key? key, this.categoryId}) : super(key: key);
  static const routeName = '/categories-filter';

  final int? categoryId;

  @override
  State<CategoriesFilter> createState() => _CategoriesFilterState();
}

class _CategoriesFilterState extends State<CategoriesFilter> {
  @override
  Widget build(BuildContext context) {
    int? categoryId = widget.categoryId;
    return Consumer<ProductsProvider>(
      builder: (context, productsData, child) => FutureBuilder<List<Product>>(
        future: productsData.getProductByCategory(categoryId!),
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
                Text(
                  "No items found",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
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
