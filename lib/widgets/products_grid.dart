import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavoritesOnly;

  ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ),
    );
  }
}
