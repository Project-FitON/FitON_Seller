import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get status bar height and screen width
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioned top container - partial width with curved bottom
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: screenWidth * 0.65, // Approximately half of the screen width
              height: 120 + statusBarHeight,
              decoration: const BoxDecoration(
                color: Color(0xFF1A0038), // Dark purple
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // Top header area with back button and title
              Container(
                height: 120 + statusBarHeight,
                padding: EdgeInsets.only(
                  top: statusBarHeight + 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button with navigation
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title and notification - positioned to match the purple background
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WISHLIST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '5 New Wishes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Wishlist Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        // Total Wishes Card
                        Expanded(
                          child: _buildSummaryCard(
                            icon: Icons.favorite,
                            value: '123',
                            label: 'Total Wishes',
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Potential Revenue Card
                        Expanded(
                          child: _buildSummaryCard(
                            icon: Icons.account_balance_wallet,
                            value: 'Rs 3.2K',
                            label: 'Potential Revenue',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Wishlist Items
                    _buildWishlistItem(
                      image: 'assets/summer_dress.png',
                      name: 'Summer Floral Dress',
                      wishes: 32,
                      sizes: ['S', 'M', 'L'],
                      colors: [Colors.pink, Colors.blue, Colors.amber],
                    ),

                    const SizedBox(height: 16),

                    _buildWishlistItem(
                      image: 'assets/denim_jacket.png',
                      name: 'Denim Jacket',
                      wishes: 28,
                      sizes: ['M', 'L', 'XL'],
                      colors: [Colors.blue, Colors.black],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1A0038),
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A0038),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem({
    required String image,
    required String name,
    required int wishes,
    required List<String> sizes,
    required List<Color> colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 70,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  image,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      name.contains('Dress') ? Icons.female : Icons.accessibility,
                      size: 40,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A0038),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Wishes Count
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$wishes wishes',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Size Options
                  Row(
                    children: [
                      ...sizes.map((size) => _buildSizeOption(size)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Color Options
                  Row(
                    children: [
                      ...colors.map((color) => _buildColorOption(color)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          size,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}