import 'package:flutter/material.dart';
import 'package:fiton_seller/screens/nav/nav_screen.dart';
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedSize;
  int? selectedColor;
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  final List<Map<String, dynamic>> colors = [
    {'id': 1, 'color': const Color(0xFF8B0000)},
    {'id': 2, 'color': const Color(0xFF006400)},
    {'id': 3, 'color': const Color(0xFF00008B)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF2D0C57),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'ADD PRODUCT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageUploader(),
          const SizedBox(height: 20),
          _buildColorSelector(),
          const SizedBox(height: 20),
          _buildTitleInput(),
          const SizedBox(height: 20),
          _buildSizeSelector(),
        ],
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picker
      },
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text('Main Photo'),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Colors',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            ...colors.map((color) => _buildColorItem(color)),
            _buildAddColorButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildColorItem(Map<String, dynamic> color) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color['id'];
            });
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color['color'],
              shape: BoxShape.circle,
              border: selectedColor == color['id']
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color['color'].withOpacity(0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildAddColorButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement add color functionality
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: const Icon(Icons.add, size: 20),
      ),
    );
  }

  Widget _buildTitleInput() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Garment Title',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        TextField(
          decoration: InputDecoration(border: UnderlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sizes Available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: sizes.map((size) => _buildSizeButton(size)).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeButton(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selectedSize == size ? const Color(0xFF2D0C57) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedSize == size ? const Color(0xFF2D0C57) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: selectedSize == size ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
