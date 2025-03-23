import 'package:fiton_seller/screens/income/income_screen.dart';
import 'package:fiton_seller/screens/orders/orders_screen.dart';
import 'package:fiton_seller/screens/shop/shop_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fiton_seller/screens/add_products/add_product_screen.dart';
import 'package:fiton_seller/screens/dashboard/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton_seller/services/shop_service.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  String? _currentShopId;
  bool _isLoading = true;
  late SupabaseService _supabaseService;

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService(Supabase.instance.client);
    _loadShopData();
  }

  Future<void> _loadShopData() async {
    try {
      final shopId = await _supabaseService.getCurrentUserShopId();
      if (shopId == null) {
        // Show error message if no shop ID is found
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No shop found. Please create a shop first.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      setState(() {
        _currentShopId = shopId;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading shop data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading shop data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> get _screens => [
    if (_currentShopId != null) ...[
      DashboardScreen(shopId: _currentShopId!),
      OrderScreen(shopId: _currentShopId!),
      const Center(child: Text('')), // Placeholder for Add Product button
      IncomeScreen(shopId: _currentShopId!),
      ShopScreen(shopId: _currentShopId!),
    ] else ...[
      const Center(child: Text('No shop found. Please create a shop first.')),
      const Center(child: Text('No shop found. Please create a shop first.')),
      const Center(child: Text('')),
      const Center(child: Text('No shop found. Please create a shop first.')),
      const Center(child: Text('No shop found. Please create a shop first.')),
    ],
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Open AddProductScreen without changing nav state
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _currentShopId != null 
            ? AddProductScreen(shopId: _currentShopId!)
            : const Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (index < _screens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1B0331),
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dash',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1B0331),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Income',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Shop',
            ),
          ],
        ),
      ),
    );
  }
}