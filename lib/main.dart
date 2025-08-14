import 'package:ecommerce_provider/services/services.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'provider/cart_provider.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  // Tap on notification -> open CartScreen
  NotificationService.setCartNotificationTapCallback(() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  });

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
        ChangeNotifierProvider.value(value: productProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
