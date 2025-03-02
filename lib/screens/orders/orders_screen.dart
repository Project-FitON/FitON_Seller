import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F0A38), // Dark purple background color
      body: SafeArea(
        child: Column(
          children: [
            // Top section with title and on-time rate
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDERS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '7 Actions Needed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B2653), // Darker purple for the card
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          '95%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'On-time',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.watch_later_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Order category tabs
            Container(
              height: 70,
              color: const Color(0xFF1F0A38), // Dark purple background
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 15),
                  _buildCategoryTab(
                    icon: Icons.grid_view,
                    label: 'All',
                    isSelected: true,
                  ),
                  _buildCategoryTab(
                    icon: Icons.receipt_outlined,
                    label: 'To Confirm',
                    count: 1,
                  ),
                  _buildCategoryTab(
                    icon: Icons.inventory_2_outlined,
                    label: 'To Pack',
                    count: 2,
                  ),
                  _buildCategoryTab(
                    icon: Icons.local_shipping_outlined,
                    label: 'To Ship',
                    count: 4,
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
           const SizedBox(height: 15),
            // Orders list (scrollable)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 15),
                  children: [
                    _buildOrderItem(
                      productName: 'Dark Red Blouse',
                      orderNumber: '283101',
                      size: 'L',
                      quantity: 2,
                      status: 'To Ship',
                      imageAsset: 'assets/red_blouse.png',
                      colorCode: Colors.red[900]!,
                      timeLeft: '2h 15m 10s left',
                      actionButtonText: 'Mark as Shipped',
                    ),
                    _buildOrderItem(
                      productName: 'Blue Summer Dress',
                      orderNumber: '283102',
                      size: 'M',
                      quantity: 1,
                      status: 'To Pack',
                      imageAsset: 'assets/blue_dress.png',
                      colorCode: Colors.blue[900]!,
                      timeLeft: '2h 15m 54s left',
                      actionButtonText: 'Mark as Packed',
                    ),
                    _buildOrderItem(
                      productName: 'Slim Fit Jeans',
                      orderNumber: '283103',
                      size: '32',
                      quantity: 1,
                      status: 'To Confirm',
                      imageAsset: 'assets/jeans.png',
                      colorCode: Colors.indigo[900]!,
                      timeLeft: '45m 24s left',
                      showConfirmCancelButtons: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCategoryTab({
    required IconData icon,
    required String label,
    int? count,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white
            : const Color(0xFF3B2653),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF1F0A38) : Colors.white,
                size: 18,
              ),
              if (count != null) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1F0A38) : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String productName,
    required String orderNumber,
    required String size,
    required int quantity,
    required String status,
    required String imageAsset,
    required Color colorCode,
    required String timeLeft,
    String? actionButtonText,
    bool showConfirmCancelButtons = false,
  }) {
    // Determine status color and background
    Color statusBgColor;
    Color statusTextColor = Colors.black;

    switch (status) {
      case 'To Ship':
        statusBgColor = Colors.orange.shade100;
        break;
      case 'To Pack':
        statusBgColor = Colors.blue.shade100;
        break;
      case 'To Confirm':
        statusBgColor = Colors.green.shade100;
        break;
      default:
        statusBgColor = Colors.grey.shade200;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 15),
                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Order #$orderNumber',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Size: $size | Qty: $quantity',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: colorCode,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Bottom row with timer and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.sync,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      timeLeft,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (!showConfirmCancelButtons && actionButtonText != null)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F0A38),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      actionButtonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                if (showConfirmCancelButtons)
                  Row(
                    children: [
                      // Cancel button
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Confirm button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F0A38),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Confirm Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}