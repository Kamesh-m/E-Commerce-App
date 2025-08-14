import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../services/services.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    return _items.values.fold(
      0.0,
          (sum, item) => sum + (item.price * item.quantity),
    );
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(
      _items.map((key, item) => MapEntry(key, item.toMap())),
    );
    await prefs.setString('cart', jsonData);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cart')) return;

    final extractedData =
    jsonDecode(prefs.getString('cart')!) as Map<String, dynamic>;
    _items = extractedData.map(
          (key, value) => MapEntry(key, CartItem.fromMap(value)),
    );
    notifyListeners();
  }

  void addItem(String productId, String title, double price, String image) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
          image: existing.image,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
          image: image,
        ),
      );
    }

    _saveCartToPrefs();

    // Show system notification
    NotificationService.showCartNotification(title);

    // Show in-app banner
    // showSimpleNotification(
    //   Text("$title added to your cart"),
    //   leading: Image.network(image, width: 40, height: 40, fit: BoxFit.cover),
    //   background: Colors.green,
    //   autoDismiss: true,
    //   duration: const Duration(seconds: 3),
    //   slideDismissDirection: DismissDirection.up,
    // );

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartToPrefs();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }
}
