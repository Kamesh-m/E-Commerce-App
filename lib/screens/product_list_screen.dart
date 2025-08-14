import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchInitialProducts();

    _scrollController.addListener(() {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.loadMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      body:
          productProvider.isLoading && productProvider.products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : productProvider.error != null
              ? Center(child: Text('Error: ${productProvider.error}'))
              : ListView.builder(
                controller: _scrollController,
                itemCount:
                    productProvider.products.length +
                    (productProvider.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < productProvider.products.length) {
                    final product = productProvider.products[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.title),
                        subtitle: Text('\$${product.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            cartProvider.addItem(
                              product.id,
                              product.title,
                              product.price,
                              product.image,
                            );
                            // Provider.of<CartProvider>(context, listen: false).addItem(Product);

                          },
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
    );
  }
}
