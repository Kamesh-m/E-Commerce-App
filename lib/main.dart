import 'package:ecommerce_provider/provider/cart_provider.dart';
import 'package:ecommerce_provider/provider/order_provider.dart';
import 'package:ecommerce_provider/provider/product_provider.dart';
import 'package:ecommerce_provider/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cartProvider = CartProvider();
  await cartProvider.loadCartFromPrefs();

  final orderProvider = OrderProvider();
  await orderProvider.loadOrdersFromPrefs();

  final productProvider = ProductProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cartProvider),
        ChangeNotifierProvider.value(value: orderProvider),
        ChangeNotifierProvider.value(value: productProvider)
      ],
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
