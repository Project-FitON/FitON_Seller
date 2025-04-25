import 'package:fiton_seller/screens/add_products/add_product_screen.dart';
import 'package:fiton_seller/screens/nav/nav_screen.dart'; // Import NavScreen
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AddProductPage(), // ✅ Set NavScreen as the home screen
    );
  }
}
