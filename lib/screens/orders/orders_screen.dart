import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton_seller/services/shop_service.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final String shopId;

  const OrderScreen({super.key, required this.shopId});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isUpdating = false;
  List<Map<String, dynamic>> _orders = [];
  String _selectedCategory = 'All';
  Map<String, int> _statusCounts = {'Unpaid': 0, 'To Ship': 0, 'In Transit': 0};

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items (
              *,
              products (
                name,
                images
              )
            )
          ''')
          .eq('shop_id', widget.shopId)
          .order('created_at', ascending: false);

      final orders = List<Map<String, dynamic>>.from(response);

      // Calculate status counts
      final counts = {'Unpaid': 0, 'To Ship': 0, 'In Transit': 0};

      for (final order in orders) {
        final status = order['status']?.toString() ?? '';
        if (status == 'Unpaid')
          counts['Unpaid'] = (counts['Unpaid'] ?? 0) + 1;
        else if (status == 'To Ship')
          counts['To Ship'] = (counts['To Ship'] ?? 0) + 1;
        else if (status == 'In Transit')
          counts['In Transit'] = (counts['In Transit'] ?? 0) + 1;
      }

      setState(() {
        _orders = orders;
        _statusCounts = counts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading orders: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredOrders {
    if (_selectedCategory == 'All') return _orders;

    return _orders.where((order) {
      final status = order['status']?.toString() ?? '';
      if (_selectedCategory == 'Unpaid') return status == 'Unpaid';
      if (_selectedCategory == 'To Ship') return status == 'To Ship';
      if (_selectedCategory == 'In Transit') return status == 'In Transit';
      return false;
    }).toList();
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      // Ensure status matches exact database values
      await _supabase
          .from('orders')
          .update({'status': newStatus})
          .eq('order_id', orderId);

      // Refresh orders after update
      await _loadOrders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error updating status: $e'); // Add detailed error logging
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _confirmOrder(String orderId) async {
    await _updateOrderStatus(orderId, 'To Ship');
  }

  Future<void> _markAsInTransit(String orderId) async {
    await _updateOrderStatus(orderId, 'In Transit');
  }

  Future<void> _markAsDelivered(String orderId) async {
    await _updateOrderStatus(orderId, 'Delivered');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F0A38),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with title and on-time rate
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ORDERS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_statusCounts.values.fold(0, (sum, count) => sum + count)} Actions Needed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B2653),
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
              color: const Color(0xFF1F0A38),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 15),
                  _buildCategoryTab(
                    icon: Icons.grid_view,
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                  ),
                  _buildCategoryTab(
                    icon: Icons.receipt_outlined,
                    label: 'Unpaid',
                    count: _statusCounts['Unpaid'],
                    isSelected: _selectedCategory == 'Unpaid',
                  ),
                  _buildCategoryTab(
                    icon: Icons.inventory_2_outlined,
                    label: 'To Ship',
                    count: _statusCounts['To Ship'],
                    isSelected: _selectedCategory == 'To Ship',
                  ),
                  _buildCategoryTab(
                    icon: Icons.local_shipping_outlined,
                    label: 'In Transit',
                    count: _statusCounts['In Transit'],
                    isSelected: _selectedCategory == 'In Transit',
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Orders list
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                          onRefresh: _loadOrders,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 15),
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = filteredOrders[index];
                              final orderItems =
                                  List<Map<String, dynamic>>.from(
                                    order['order_items'] ?? [],
                                  );
                              if (orderItems.isEmpty)
                                return const SizedBox.shrink();

                              final firstItem = orderItems.first;
                              final product =
                                  firstItem['products']
                                      as Map<String, dynamic>?;
                              final imageUrl =
                                  product != null &&
                                          product['images'] is List &&
                                          (product['images'] as List).isNotEmpty
                                      ? (product['images'] as List).first
                                          .toString()
                                      : null;

                              return _buildOrderItem(
                                productName:
                                    product?['name'] ?? 'Unknown Product',
                                orderNumber:
                                    order['order_id']?.toString().substring(
                                      0,
                                      6,
                                    ) ??
                                    'N/A',
                                orderId: order['order_id']?.toString() ?? '',
                                size: firstItem['selected_size'] ?? 'N/A',
                                quantity: firstItem['quantity'] ?? 1,
                                status: _getStatusLabel(
                                  order['status']?.toString() ?? '',
                                ),
                                imageUrl: imageUrl,
                                orderDate:
                                    DateTime.tryParse(
                                      order['created_at']?.toString() ?? '',
                                    ) ??
                                    DateTime.now(),
                                totalPrice:
                                    double.tryParse(
                                      order['total_price']?.toString() ?? '0',
                                    ) ??
                                    0.0,
                                showConfirmCancelButtons:
                                    order['status']?.toString() == 'Unpaid',
                              );
                            },
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'Unpaid':
        return 'Unpaid';
      case 'To Ship':
        return 'To Ship';
      case 'In Transit':
        return 'In Transit';
      case 'Delivered':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  Widget _buildCategoryTab({
    required IconData icon,
    required String label,
    int? count,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF3B2653),
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
                if (count != null && count > 0) ...[
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
      ),
    );
  }

  Widget _buildOrderItem({
    required String productName,
    required String orderNumber,
    required String orderId,
    required String size,
    required int quantity,
    required String status,
    String? imageUrl,
    required DateTime orderDate,
    required double totalPrice,
    bool showConfirmCancelButtons = false,
  }) {
    Color statusBgColor;
    Color statusTextColor = Colors.black;

    switch (status.toLowerCase()) {
      case 'unpaid':
        statusBgColor = Colors.orange.shade100;
        break;
      case 'to ship':
        statusBgColor = Colors.blue.shade100;
        break;
      case 'in transit':
        statusBgColor = Colors.green.shade100;
        break;
      case 'delivered':
        statusBgColor = Colors.purple.shade100;
        break;
      default:
        statusBgColor = Colors.grey.shade200;
    }

    // Calculate time left (24 hours from order creation)
    final timeLeft = orderDate
        .add(const Duration(hours: 24))
        .difference(DateTime.now());
    final timeLeftString =
        timeLeft.isNegative
            ? 'Overdue'
            : '${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m ${timeLeft.inSeconds.remainder(60)}s left';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with ID and status dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${orderNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: status,
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      elevation: 8,
                      style: TextStyle(
                        color: statusTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      items:
                          <String>[
                            'Unpaid',
                            'To Ship',
                            'In Transit',
                            'Delivered',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged:
                          _isUpdating
                              ? null
                              : (String? newValue) async {
                                if (newValue != null && newValue != status) {
                                  await _updateOrderStatus(orderId, newValue);
                                }
                              },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product details
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
                  child:
                      imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey[400],
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                          ),
                ),
                const SizedBox(width: 15),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size: $size | Qty: $quantity',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1F0A38),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order date and time left
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordered on ${DateFormat('MMM d, y').format(orderDate)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: timeLeft.isNegative ? Colors.red : Colors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeLeftString,
                      style: TextStyle(
                        color: timeLeft.isNegative ? Colors.red : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Action buttons
            if (showConfirmCancelButtons ||
                status == 'To Ship' ||
                status == 'In Transit')
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showConfirmCancelButtons) ...[
                        OutlinedButton(
                          onPressed:
                              _isUpdating
                                  ? null
                                  : () async {
                                    await _confirmOrder(orderId);
                                  },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child:
                              _isUpdating
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey.shade600,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Confirm Order',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed:
                              _isUpdating
                                  ? null
                                  : () async {
                                    await _markAsInTransit(orderId);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F0A38),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child:
                              _isUpdating
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Mark as In Transit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                        ),
                      ] else
                        ElevatedButton(
                          onPressed:
                              _isUpdating
                                  ? null
                                  : () async {
                                    await _markAsDelivered(orderId);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F0A38),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child:
                              _isUpdating
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Mark as Delivered',
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
