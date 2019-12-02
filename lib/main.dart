import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/products_overview_page.dart';
import 'package:shop_app/providers/cart.dart';

import './providers/products_provider.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './pages/product_detail_page.dart';
import './pages/cart_page.dart';
import './pages/orders_page.dart';
import './pages/user_products_page.dart';
import './pages/edit_product_page.dart';
import './pages/auth_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          builder: (context, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (context, auth, previousOrders) => Orders(
              auth.token, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewPage() : AuthPage(),
          routes: {
            ProductDetailPage.routeName: (context) => ProductDetailPage(),
            CartPage.routeName: (context) => CartPage(),
            OrdersPage.routeName: (context) => OrdersPage(),
            UserProductsPage.routeName: (context) => UserProductsPage(),
            EditProductPage.routeName: (context) => EditProductPage(),
          },
        ),
      ),
    );
  }
}
