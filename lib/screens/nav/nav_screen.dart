import 'package:fiton_seller/screens/income/income_screen.dart';
import 'package:fiton_seller/screens/orders/orders_screen.dart';
import 'package:fiton_seller/screens/shop/shop_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fiton_seller/screens/add_products/add_product_screen.dart';
import 'package:fiton_seller/screens/dashboard/dashboard_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const OrderScreen(),
    const Center(child: Text('Income')), // Placeholder
    const IncomeScreen(),
    const ShopScreen(),// Added a placeholder for Shop
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Open AddProductScreen without changing nav state
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddProductScreen()),
      );
    } else if (index < _screens.length) { // Prevent out-of-range index
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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