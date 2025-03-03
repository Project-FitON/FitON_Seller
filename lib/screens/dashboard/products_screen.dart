import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const Center(
        child: Text(
          'This is the Products Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
