import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // App theme colors
  final Color _headerBackgroundColor = const Color(0xFF1B0331); // Dark purple for header
  final Color _contentBackgroundColor = Colors.white; // White for content area
  final Color _primaryPurple = const Color(0xFF341259); // Main purple for selected items
  final Color _accentPurple = const Color(0xFF4D1E7F); // Lighter purple for buttons/accents

  final List<Map<String, dynamic>> _categories = [
    {'icon': FontAwesomeIcons.shapes, 'label': 'All'},
    {'icon': FontAwesomeIcons.shirt, 'label': 'T-shirt'},
    {'icon': FontAwesomeIcons.briefcase, 'label': 'Office'},
    {'icon': FontAwesomeIcons.personRunning, 'label': 'Sport'},
    {'icon': FontAwesomeIcons.ellipsis, 'label': 'More'},
  ];

  final List<Map<String, dynamic>> _clothingItems = [
    {
      'image': 'assets/images/casual_1.jpg',
      'isFeatured': false,
    },
    {
      'image': 'assets/images/casual_2.jpg',
      'isFeatured': true,
    },
    {
      'image': 'assets/images/casual_3.jpg',
      'isFeatured': false,
    },
    {
      'image': 'assets/images/casual_4.jpg',
      'isFeatured': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeCategory(int index) {
    if (_selectedCategoryIndex != index) {
      setState(() {
        _selectedCategoryIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildClothingGrid(),
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
            child: Image.asset('assets/images/logo.png', height: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Fashion',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '7,388,478',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
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
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
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
                      boxShadow: isSelected
                          ? [BoxShadow(
                        color: _primaryPurple.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )]
                          : null,
                    ),
                    child: Icon(
                      _categories[index]['icon'],
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _categories[index]['label'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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

  Widget _buildClothingGrid() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _accentPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '124 Casual Clothes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _clothingItems.length,
              itemBuilder: (context, index) {
                final item = _clothingItems[index];
                return Hero(
                  tag: 'clothing_${index}',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Handle item tap with animation
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                item['image'],
                                fit: BoxFit.cover,
                              ),
                              if (item['isFeatured'])
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: SizedBox(
                                    width: 100,
                                    height: 140,
                                    child: OverflowBox(
                                      maxWidth: 160,
                                      maxHeight: 200,
                                      child: Transform.translate(
                                        offset: const Offset(30, -30),
                                        child: Image.asset(
                                          'assets/images/casual_featured.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}