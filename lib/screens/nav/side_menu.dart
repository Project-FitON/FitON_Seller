import 'package:flutter/material.dart';

class SideMenuBar extends StatefulWidget {
  const SideMenuBar({super.key});

  @override
  State<SideMenuBar> createState() => _SideMenuBarState();
}

class _SideMenuBarState extends State<SideMenuBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final halfHeight = screenHeight * 0.5;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: 50,
          height: halfHeight,
          child: Material(
            elevation: 8,
            color: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuItem(Icons.color_lens_outlined, 0),
                  _buildMenuItem(Icons.local_offer_outlined, 1),
                  _buildMenuItem(Icons.store_mall_directory_outlined, 2),
                  _buildMenuItem(Icons.format_size_outlined, 3),
                  _buildMenuItem(Icons.message_outlined, 4),
                  _buildMenuItem(Icons.local_shipping_outlined, 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: IconButton(
        icon: Icon(
          icon,
          color: isSelected ? const Color(0xFF2D0C57) : Colors.grey,
          size: 24,
        ),
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        tooltip: 'Menu Item ${index + 1}',
      ),
    );
  }
}