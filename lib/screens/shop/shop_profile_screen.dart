import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton_seller/services/shop_service.dart';

import '../../models/shop_model.dart';

class ShopScreen extends StatefulWidget {
  final String shopId;

  const ShopScreen({super.key, required this.shopId});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late SupabaseService _supabaseService;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  Shop? _shopData;

  // App theme colors
  final Color _headerBackgroundColor = const Color(
    0xFF1B0331,
  ); // Dark purple for header
  final Color _contentBackgroundColor = Colors.white; // White for content area
  final Color _primaryPurple = const Color(
    0xFF341259,
  ); // Main purple for selected items
  final Color _accentPurple = const Color(
    0xFF4D1E7F,
  ); // Lighter purple for buttons/accents

  final List<Map<String, dynamic>> _categories = [
    {'icon': FontAwesomeIcons.shapes, 'label': 'All'},
    {'icon': FontAwesomeIcons.shirt, 'label': 'T-shirt'},
    {'icon': FontAwesomeIcons.briefcase, 'label': 'Office'},
    {'icon': FontAwesomeIcons.personRunning, 'label': 'Sport'},
    {'icon': FontAwesomeIcons.ellipsis, 'label': 'More'},
  ];

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService(Supabase.instance.client);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadShopData();
    _loadProducts();
  }

  Future<void> _loadShopData() async {
    try {
      final shopData = await _supabaseService.getCurrentShop(widget.shopId);
      if (shopData != null) {
        setState(() {
          _shopData = shopData;
        });
      }
    } catch (e) {
      print('Error loading shop data: $e');
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final category =
          _selectedCategoryIndex == 0
              ? null
              : _categories[_selectedCategoryIndex]['label'];
      final products = await _supabaseService.getShopProducts(
        category: category,
        sortBy: 'created_at',
        ascending: false,
      );

      setState(() {
        _products = products;
        _isLoading = false;
      });
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeCategory(int index) {
    if (_selectedCategoryIndex != index) {
      setState(() {
        _selectedCategoryIndex = index;
      });
      _loadProducts();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Purple top section
          Container(
            color: _headerBackgroundColor,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildCategoryBar(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // White content section
          Expanded(
            child: Container(
              color: _contentBackgroundColor,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildProductGrid(),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage:
                _shopData?.profilePhoto != null
                    ? NetworkImage(_shopData!.profilePhoto!)
                    : null,
            child:
                _shopData?.profilePhoto == null
                    ? Image.asset('assets/images/logo.png', height: 32)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _shopData?.name ?? 'Loading...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${_products.length} Products',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildIconButton(Icons.telegram_outlined),
          const SizedBox(width: 8),
          _buildIconButton(FontAwesomeIcons.whatsapp),
          const SizedBox(width: 8),
          _buildIconButton(FontAwesomeIcons.instagram),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }

  Widget _buildCategoryBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 32) / 5; // Account for padding

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (index) {
          final bool isSelected = _selectedCategoryIndex == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: itemWidth - 8, // Subtract for spacing
            child: GestureDetector(
              onTap: () => _changeCategory(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryPurple : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: _primaryPurple.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                              : null,
                    ),
                    child: Icon(
                      _categories[index]['icon'],
                      color:
                          isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _categories[index]['label'],
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final isFeatured = product['is_featured'] ?? false;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              // Product Image
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        (product['images'] as List?)?.firstOrNull?.toString() ??
                            'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (isFeatured)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Product Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Unnamed Product',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _primaryPurple,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
