import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final newOrder = OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );
    _orders.insert(0, newOrder);
    await saveOrdersToPrefs(); // auto-save on add
    notifyListeners();
  }

  Future<void> saveOrdersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersData = _orders.map((o) => o.toMap()).toList();
    prefs.setString('orders', json.encode(ordersData));
  }

  Future<void> loadOrdersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('orders')) return;

    final extractedData =
    json.decode(prefs.getString('orders')!) as List<dynamic>;
    _orders = extractedData
        .map((o) => OrderItem.fromMap(o as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }
}