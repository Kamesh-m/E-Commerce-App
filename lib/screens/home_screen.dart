import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'cart_screen.dart';
import 'orders.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProductListScreen(),
    const CartScreen(),
    const OrdersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce App"),
        // actions: [
        //   // Cart icon in AppBar with badge
        //   Stack(
        //     clipBehavior: Clip.none,
        //     children: [
        //       IconButton(
        //         icon: const Icon(Icons.shopping_cart),
        //         onPressed: () {
        //           setState(() {
        //             _selectedIndex = 1; // Navigate to Cart tab
        //           });
        //         },
        //       ),
        //       Selector<CartProvider, int>(
        //         selector: (_, cart) => cart.items.length,
        //         builder: (_, count, __) {
        //           if (count == 0) return const SizedBox();
        //           return Positioned(
        //             right: 4,
        //             top: 4,
        //             child: Container(
        //               padding: const EdgeInsets.all(2),
        //               decoration: BoxDecoration(
        //                 color: Colors.red,
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               constraints: const BoxConstraints(
        //                 minWidth: 18,
        //                 minHeight: 18,
        //               ),
        //               child: Text(
        //                 count.toString(),
        //                 style: const TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 12,
        //                 ),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        // ],
      ),

      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                Selector<CartProvider, int>(
                  selector: (_, cart) => cart.items.length,
                  builder: (_, count, __) {
                    if (count == 0) return const SizedBox();
                    return Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
