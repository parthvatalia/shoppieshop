import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './screens/auth_screen.dart';
import './screens/product_listing_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/checkout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (ctx, auth, previousProducts) =>
              previousProducts!..update(auth.token),
        ),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Shop',
          home: FutureBuilder(
            future: Future.wait([
              auth.tryAutoLogin(),
              Provider.of<CartProvider>(ctx, listen: false).loadCartFromLocalStorage(),
            ]),
            builder: (ctx, authResultSnapshot) =>
            auth.isAuth ? ProductListingScreen() : const AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) =>  CartScreen(),
            CheckoutScreen.routeName: (ctx) =>  CheckoutScreen(),
          },
        ),
      ),
    );
  }
}
