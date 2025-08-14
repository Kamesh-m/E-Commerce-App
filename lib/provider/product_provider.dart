import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final int _limit = 10;
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  List<Product> _allProducts = [];
  List<Product> _products = [];

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> fetchInitialProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get all products once
      _allProducts = await ApiService.fetchProducts();
      _products = _allProducts.take(_limit).toList();
      _page = 1;
      _hasMore = _products.length < _allProducts.length;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final startIndex = _page * _limit;
    final endIndex = startIndex + _limit;

    final nextPageItems = _allProducts.sublist(
      startIndex,
      endIndex > _allProducts.length ? _allProducts.length : endIndex,
    );

    _products.addAll(nextPageItems);
    _page++;
    _hasMore = _products.length < _allProducts.length;

    _isLoading = false;
    notifyListeners();
  }
}
