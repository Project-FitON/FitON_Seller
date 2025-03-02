import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: const Center(
        child: Text(
          'This is the Sales Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
