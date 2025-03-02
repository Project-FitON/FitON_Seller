import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom curved purple header
          Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFF1B0331),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'NOTIFICATIONS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '5 Unreads',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Notifications List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildNotificationCard(
                  icon: Icons.shopping_bag,
                  backgroundColor: const Color(0xFF2D1F3D),
                  title: 'New Order Received',
                  message: 'Order #2458 for Purple Dress',
                  time: '2 hours ago',
                ),
                _buildNotificationCard(
                  icon: Icons.warning,
                  backgroundColor: const Color(0xFFFF4B4B),
                  title: 'Low Stock Alert',
                  message: 'Black T-shirt (Size M) is running low',
                  time: '5 hours ago',
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 20, bottom: 12),
                  child: Text(
                    'Yesterday',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildNotificationCard(
                  icon: Icons.payments_outlined,
                  backgroundColor: const Color(0xFF4CAF50),
                  title: 'Payment Received',
                  message: '\$129.99 from Order #2457',
                  time: 'Yesterday, 14:30',
                ),
                _buildNotificationCard(
                  icon: Icons.star,
                  backgroundColor: const Color(0xFFFFB800),
                  title: 'New Review',
                  message: '5★ review for Blue Jeans',
                  time: 'Yesterday, 09:15',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color backgroundColor,
    required String title,
    required String message,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),  // Increased opacity
            spreadRadius: 1,                        // Added spread
            blurRadius: 10,                        // Increased blur
            offset: const Offset(0, 3),            // Slightly larger offset
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}