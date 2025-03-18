import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistScreen extends StatefulWidget {
  final String shopId;
  
  const WishlistScreen({
    Key? key,
    required this.shopId,
  }) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  int _totalWishes = 0;
  double _potentialRevenue = 0;

  @override
  void initState() {
    super.initState();
    _loadWishlistData();
  }

  Future<void> _loadWishlistData() async {
    try {
      final supabase = Supabase.instance.client;
      
      // Fetch products that belong to this shop and have wishes
      final response = await supabase
          .from('products')
          .select('*')
          .eq('shop_id', widget.shopId)
          .gt('wish', 0); // Only get products with wishes greater than 0

      if (mounted) {
        setState(() {
          _products = List<Map<String, dynamic>>.from(response);
          _totalWishes = _products.fold(0, (sum, product) => 
            sum + (product['wish'] as int? ?? 0));
          _potentialRevenue = _products.fold(0.0, (sum, product) => 
            sum + (double.tryParse(product['price'].toString()) ?? 0) * (product['wish'] as int? ?? 0));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading wishlist data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top App Bar - Full width with curved bottom
          Container(
            width: double.infinity,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFF1A0038),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WISHLIST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Text(
                            '$_totalWishes Total Wishes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Wishlist Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Summary Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              icon: Icons.favorite,
                              value: _totalWishes.toString(),
                              label: 'Total Wishes',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSummaryCard(
                              icon: Icons.account_balance_wallet,
                              value: 'Rs ${_potentialRevenue.toStringAsFixed(2)}',
                              label: 'Potential Revenue',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Wishlist Items
                      ..._products.map((product) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildWishlistItem(
                          image: product['image_url'] ?? '',
                          name: product['name'] ?? 'Unnamed Product',
                          wishes: product['wish'] ?? 0,
                          price: double.tryParse(product['price'].toString()) ?? 0.0,
                          sizes: List<String>.from(product['sizes'] ?? []),
                          colors: (product['colors'] as List?)?.map<Color>((c) => 
                            Color(int.parse(c.toString().replaceAll('#', '0xFF'))))
                            .toList() ?? [],
                        ),
                      )).toList(),
                    ],
                  ),
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
    required double price,
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
                child: Image.network(
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