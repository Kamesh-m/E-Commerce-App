// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final orders = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: cart.items.isEmpty
                        ? null
                        : () async {
                      // Save order before clearing cart
                      await orders.addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      await orders.saveOrdersToPrefs(); // persist orders
                      cart.clear(); // clears cart & updates prefs

                      // Navigate to orders screen
                      // if (context.mounted) {
                      //   Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(
                      //       builder: (_) => const OrdersScreen(),
                      //     ),
                      //   );
                      // }
                    },
                    child: const Text('CHECKOUT'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text("Your cart is empty"))
                : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final cartItem = cart.items.values.toList()[i];
                final productId = cart.items.keys.toList()[i];

                return Dismissible(
                  key: ValueKey(cartItem.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cart.removeItem(productId);
                  },
                  child: ListTile(
                    leading: Image.network(
                      cartItem.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cartItem.title),
                    subtitle: Text(
                      'Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                    ),
                    trailing: Text('${cartItem.quantity} x'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
