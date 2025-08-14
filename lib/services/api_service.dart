import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts({int total = 100}) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("✅ Raw API Data Count: ${data.length}");

      List<Product> products = [];

      int multiplier = (total / data.length).ceil(); // How many times to duplicate
      for (int i = 0; i < multiplier; i++) {
        for (var json in data) {
          var newJson = Map<String, dynamic>.from(json);
          newJson['id'] = newJson['id'] + (i * data.length); // unique ID
          newJson['title'] = '${newJson['title']} #${i + 1}'; // modify title slightly
          products.add(Product.fromJson(newJson));
        }
      }

      // Trim in case it exceeds the requested total
      if (products.length > total) {
        products = products.sublist(0, total);
      }

      print("✅ Extended Products Count: ${products.length}");
      return products;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
