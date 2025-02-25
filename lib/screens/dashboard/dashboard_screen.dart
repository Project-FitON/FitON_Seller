import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'wishlist_screen.dart';
import 'products_screen.dart';
import 'sales_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required String shopId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;
  String shopName = "Loading...";
  int followersCount = 0;
  int orderCount = 0;
  int reviewCount = 0;
  String latestOrder = "No recent orders";
  String latestReview = "No recent reviews";

  @override
  void initState() {
    super.initState();
    fetchShopDetails();
  }

  Future<void> fetchShopDetails() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('shops')
        .select('name, id')
        .eq('owner_id', user.id)
        .maybeSingle();

    if (response != null && mounted) {
      setState(() {
        shopName = response['name'];
      });

      fetchFollowersCount(response['id']);
      fetchOrderAndReviewCounts(response['id']);
      fetchLatestOrder(response['id']);
      fetchLatestReview(response['id']);
    }
  }

  Future<void> fetchFollowersCount(String shopId) async {
    final response = await supabase
        .from('followers')
        .select()
        .eq('shop_id', shopId);

    if (mounted) {
      setState(() {
        followersCount = response.length;
      });
    }
  }

  Future<void> fetchOrderAndReviewCounts(String shopId) async {
    final orderResponse = await supabase
        .from('orders')
        .select()
        .eq('shop_id', shopId);

    final reviewResponse = await supabase
        .from('reviews')
        .select()
        .eq('shop_id', shopId);

    if (mounted) {
      setState(() {
        orderCount = orderResponse.length;
        reviewCount = reviewResponse.length;
      });
    }
  }

  Future<void> fetchLatestOrder(String shopId) async {
    final response = await supabase
        .from('orders')
        .select('customer_name, created_at')
        .eq('shop_id', shopId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (mounted) {
      setState(() {
        latestOrder = response != null
            ? "Order from ${response['customer_name']}"
            : "No recent orders";
      });
    }
  }

  Future<void> fetchLatestReview(String shopId) async {
    final response = await supabase
        .from('reviews')
        .select('review_text, created_at')
        .eq('shop_id', shopId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (mounted) {
      setState(() {
        latestReview = response != null
            ? response['review_text']
            : "No recent reviews";
      });
    }
  }

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
                  const CircleAvatar(radius: 25, backgroundColor: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shopName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('$followersCount Followers', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard('Orders', '$orderCount', Colors.deepPurple, Icons.shopping_bag)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Reviews', '$reviewCount', Colors.white, Icons.star)),
                ],
              ),
              const SizedBox(height: 16),

              // Quick Actions
              Row(
                children: [
                  Expanded(child: _buildQuickActionButton('Wishlist', Icons.favorite, context, const WishlistScreen())),
                  const SizedBox(width: 16),
                  Expanded(child: _buildQuickActionButton('Products', Icons.shopping_cart, context, const ProductsScreen())),
                  const SizedBox(width: 16),
                  Expanded(child: _buildQuickActionButton('Sales', Icons.attach_money, context, const SalesScreen())),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Orders & Latest Reviews
              _buildSectionTitle("Recent Orders"),
              _buildTextRow(latestOrder),

              const SizedBox(height: 16),

              _buildSectionTitle("Latest Reviews"),
              _buildTextRow(latestReview),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color == Colors.white ? Colors.black : Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(value, style: TextStyle(color: color == Colors.white ? Colors.black : Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(icon, color: color == Colors.white ? Colors.black : Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, BuildContext context, Widget screen) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(16)),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextRow(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}
