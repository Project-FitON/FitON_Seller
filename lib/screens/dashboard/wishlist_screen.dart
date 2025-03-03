import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: const Center(
        child: Text(
          'This is the Wishlist Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
