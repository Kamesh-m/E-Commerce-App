
import 'cart_item.dart';




class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'products': products.map((p) => p.toMap()).toList(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      products: (map['products'] as List)
          .map((p) => CartItem.fromMap(p as Map<String, dynamic>))
          .toList(),
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
