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
import './pages/splash_screen.dart';

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
          builder: (context, auth, previousOrders) => Orders(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
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
          home: auth.isAuth
              ? ProductsOverviewPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthPage(),
                ),
          routes: {
            ProductDetailPage.routeName: (context) =>
                auth.isAuth ? ProductDetailPage() : AuthPage(),
            CartPage.routeName: (context) =>
                auth.isAuth ? CartPage() : AuthPage(),
            OrdersPage.routeName: (context) =>
                auth.isAuth ? OrdersPage() : AuthPage(),
            UserProductsPage.routeName: (context) =>
                auth.isAuth ? UserProductsPage() : AuthPage(),
            EditProductPage.routeName: (context) =>
                auth.isAuth ? EditProductPage() : AuthPage(),
          },
        ),
      ),
    );
  }
}
