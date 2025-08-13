
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order_provider.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: orders.orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (ctx, i) {
          final order = orders.orders[i];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ExpansionTile(
              title: Text(
                'Order \$${order.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                order.dateTime.toLocal().toString().split('.')[0],
              ),
              children: order.products.map((prod) {
                return ListTile(
                  leading: Image.network(
                    prod.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(prod.title),
                  subtitle: Text(
                    '\$${prod.price} x ${prod.quantity}',
                  ),
                );
              }).toList(),


            ),
          );
        },
      ),
    );
  }
}
