import 'package:fiton_seller/screens/add_products/add_product_screen.dart';
import 'package:fiton_seller/screens/shop/notification_screen.dart';
import 'package:fiton_seller/screens/shop/shop_profile_screen.dart';
import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import 'wishlist_screen.dart';
import 'products_screen.dart';
import 'sales_screen.dart';
import 'reviews_screen.dart'; // Add this import for the Reviews Screen

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Fashion',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '174 Followers',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Orders',
                      '284',
                      '+8.4%',
                      const Color(0xFF1B0331),
                      Icons.shopping_bag,
                      context,
                      null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Reviews',
                      '567',
                      '+12.8%',
                      Colors.white,
                      Icons.star,
                      context,
                      const ReviewScreen(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick Actions Row
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionButton(
                      'Wishlist',
                      Icons.favorite,
                      const Color(0xFF1B0331),
                      true,
                      context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionButton(
                      'Products',
                      Icons.shopping_cart,
                      Colors.white,
                      false,
                      context,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickActionButton(
                      'Sales',
                      Icons.attach_money,
                      Colors.white,
                      false,
                      context,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Orders Section
              _buildSectionHeader('Recent Orders', 'View All'),
              _buildOrdersList(),
              const SizedBox(height: 24),

              // Latest Reviews Section
              _buildSectionHeader('Latest Reviews', 'View All'),
              _buildReviewCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String growth, Color color, IconData icon, BuildContext context, Widget? destination) {
    final isLight = color == Colors.white;
    return GestureDetector(
      onTap: destination != null
          ? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isLight ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: isLight ? Colors.black : Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  growth,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, bool hasBadge, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the respective screen based on the title
        if (title == 'Wishlist') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WishlistScreen()),
          );
        } else if (title == 'Products') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        } else if (title == 'Sales') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShopScreen()),
          );
        }

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        elevation: 5, // shadow effect
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: color == Colors.white ? Colors.black : Colors.white,
                size: 24,
              ),
              if (hasBadge)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color == Colors.white ? Colors.black : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF1B0331),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList() {
    final List<Map<String, dynamic>> orders = [
      {
        'id': '#ORD-7829',
        'name': 'Sarah Williams',
        'amount': 156.00,
        'status': 'Processing'
      },
      {
        'id': '#ORD-7828',
        'name': 'Michael Chen',
        'amount': 243.50,
        'status': 'Completed'
      },
      {
        'id': '#ORD-7827',
        'name': 'Emily Thompson',
        'amount': 89.99,
        'status': 'Shipped'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['id'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order['name'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${(order['amount'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status'] as String),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order['status'] as String,
                      style: TextStyle(
                        color: _getStatusTextColor(order['status'] as String),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.amber.withOpacity(0.2);
      case 'completed':
        return Colors.green.withOpacity(0.2);
      case 'shipped':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.amber[800]!;
      case 'completed':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
                  (index) => const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Great product quality and fast shipping! Will definitely order again.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '2 days ago',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}