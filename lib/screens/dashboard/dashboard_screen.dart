import 'package:fiton_seller/screens/shop/notification_screen.dart';
import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase/supabase.dart' as _currentShop;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton_seller/models/shop_model.dart';
import 'package:fiton_seller/services/shop_service.dart';
import 'wishlist_screen.dart';
import 'products_screen.dart';
import 'sales_screen.dart';
import 'reviews_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  final String shopId;

  const DashboardScreen({super.key, required this.shopId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SupabaseService _supabaseService;
  Shop? _currentShop;
  bool _isLoading = true;
  List<Map<String, dynamic>> _recentOrders = [];
  List<Map<String, dynamic>> _latestReviews = [];
  Map<String, dynamic> _shopStats = {
    'orderCount': '0',
    'reviewCount': '0',
    'orderGrowth': '0.0%',
  };

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService(Supabase.instance.client);
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading dashboard data for shop ID: ${widget.shopId}');

      // Get the current shop
      _currentShop = await _supabaseService.getCurrentShop(widget.shopId);
      print(
        'Current shop: ${_currentShop != null ? "${_currentShop!.name} (${_currentShop!.id})" : "null"}',
      );

      if (_currentShop != null) {
        print('Using shop ID for queries: ${_currentShop!.id}');

        // Fetch all dashboard data in parallel
        final results = await Future.wait([
          _supabaseService.getRecentOrders(_currentShop!.id),
          _supabaseService.getLatestReviews(_currentShop!.id),
          _supabaseService.getShopStats(_currentShop!.id),
        ]);

        setState(() {
          _recentOrders = List<Map<String, dynamic>>.from(results[0] as List);
          _latestReviews = List<Map<String, dynamic>>.from(results[1] as List);
          _shopStats = results[2] as Map<String, dynamic>;
          _isLoading = false;
        });

        print('Loaded reviews count: ${_latestReviews.length}');
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentShop == null
                ? const Center(child: Text('No shop data found'))
                : RefreshIndicator(
                  onRefresh: _loadDashboardData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header with Shop Data
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  _currentShop!.profilePhoto != null
                                      ? NetworkImage(
                                        _currentShop!.profilePhoto!,
                                      )
                                      : null,
                              child:
                                  _currentShop!.profilePhoto == null
                                      ? const Icon(
                                        Icons.store,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentShop!.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${_currentShop!.nickname} · ${_currentShop!.phoneNumber}',
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
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const NotificationScreen(),
                                  ),
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
                                _shopStats['orderCount'].toString(),
                                _shopStats['orderGrowth'],
                                const Color(0xFF1B0331),
                                Icons.shopping_bag,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Reviews',
                                _shopStats['reviewCount'].toString(),
                                '+12.8%', // You might want to calculate this
                                Colors.white,
                                Icons.star,
                              ),
                            ),
                          ],
                        ),

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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Text(value, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String growth,
    Color bgColor,
    IconData icon,
  ) {
    final isLight = bgColor == Colors.white;
    final textColor = isLight ? Colors.black : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
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
          Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            growth,
            style: TextStyle(
              color: growth.startsWith('+') ? Colors.green : Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color bgColor,
    bool isHighlighted,
    BuildContext context,
  ) {
    final isLight = bgColor == Colors.white;
    final textColor = isLight ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Wishlist':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WishlistScreen(shopId: widget.shopId),
              ),
            );
            break;
          case 'Products':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsScreen(shopId: widget.shopId),
              ),
            );
            break;
          case 'Sales':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesScreen(shopId: widget.shopId),
              ),
            );
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
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
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  color: bgColor == Colors.white ? Colors.black : Colors.white,
                  size: 24,
                ),
                if (isHighlighted)
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
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              if (title == 'Latest Reviews') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewsScreen(shopId: widget.shopId),
                  ),
                );
              }
              // Handle other sections if needed
            },
            child: Text(
              action,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_recentOrders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No recent orders',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children:
          _recentOrders.take(3).map((order) {
            final orderItems = order['order_items'] as List? ?? [];
            final status =
                order['status']?.toString()?.toLowerCase() ?? 'pending';
            final paymentMethod = order['payment_method'] ?? 'N/A';
            final totalPrice =
                double.tryParse(order['total_price']?.toString() ?? '0') ?? 0.0;
            final orderDate =
                DateTime.tryParse(order['created_at']?.toString() ?? '') ??
                DateTime.now();
            final orderId = order['order_id']?.toString() ?? 'N/A';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Order Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_bag,
                            color: _getStatusColor(status),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${orderId.substring(0, 8)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        status,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        color: _getStatusColor(status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat(
                                      'MMM d, yyyy · h:mm a',
                                    ).format(orderDate),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Payment: $paymentMethod',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Order Items
                  if (orderItems.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[100],
                                ),
                                child: Center(
                                  child: Text(
                                    '${item['quantity']}x',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['product_name'] ?? 'Product',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (item['selected_size'] != null ||
                                        item['selected_color'] != null)
                                      Text(
                                        [
                                          if (item['selected_size'] != null)
                                            'Size: ${item['selected_size']}',
                                          if (item['selected_color'] != null)
                                            'Color: ${item['selected_color']}',
                                        ].join(' · '),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${(double.tryParse(item['price']?.toString() ?? '0') ?? 0.0).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  // Order Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1B0331),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Widget _buildReviewCard() {
    if (_latestReviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No reviews yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children:
          _latestReviews.take(3).map((review) {
            print('Processing review: $review'); // Debug print

            // Try to extract rating, comment, and created_at with fallbacks
            int rating = 0;
            String comment = 'No comment';
            DateTime createdAt = DateTime.now();

            try {
              // Try to get rating
              if (review.containsKey('rating')) {
                rating =
                    review['rating'] is int
                        ? review['rating']
                        : int.tryParse(review['rating'].toString()) ?? 0;
              }

              // Try to get comment
              if (review.containsKey('comment')) {
                comment = review['comment']?.toString() ?? 'No comment';
              }

              // Try to get created_at
              if (review.containsKey('created_at')) {
                createdAt =
                    DateTime.tryParse(review['created_at']?.toString() ?? '') ??
                    DateTime.now();
              }
            } catch (e) {
              print('Error processing review data: $e');
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                size: 14,
                                color:
                                    index < rating
                                        ? Colors.amber
                                        : Colors.grey[300],
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '$rating/5',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('MMM d').format(createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    comment,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
