import 'package:flutter/material.dart';
import 'package:fiton_seller/screens/nav/side_menu.dart';

class AddProductScreen extends StatelessWidget {
  final String shopId;

  const AddProductScreen({
    super.key,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B0331),
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Pops the screen when the back button is pressed
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const SizedBox(height: 20),

                  // Main Photo Container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Main Photo',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Garment Title TextField
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Garment Title',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  // Colors & Photos Section
                  const Text(
                    'Colors & Photos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Color Circles with Photos
                  Row(
                    children: [
                      _buildColorWithPhoto(Colors.red, 'assets/red_garment.jpg'),
                      const SizedBox(width: 15),
                      _buildColorWithPhoto(Colors.green, 'assets/green_garment.jpg'),
                      const SizedBox(width: 15),
                      _buildColorWithPhoto(Colors.blue, 'assets/blue_garment.jpg'),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'camera',
                        onPressed: () {},
                        backgroundColor: const Color(0xFF4A148C),
                        child: const Icon(Icons.camera_alt),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'gallery',
                        onPressed: () {},
                        backgroundColor: const Color(0xFF4A148C),
                        child: const Icon(Icons.photo_library),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Positioned the side menu at the left bottom corner
          const Positioned(
            bottom: 0,
            left: 0,
            child: SideMenuBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorWithPhoto(Color color, String imagePath) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
