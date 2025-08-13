class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      quantity: map['quantity'],
      price: (map['price'] as num).toDouble(),
      image: map['image'],
    );
  }
}
