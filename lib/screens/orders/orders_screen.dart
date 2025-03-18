import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final supabase = Supabase.instance.client;
  String selectedTab = 'All'; // Default tab

  // Fetch Orders from Supabase
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      var query = supabase.from('orders').select();

      if (selectedTab != 'All') {
        query = query.filter('status', 'eq', selectedTab);
      }

      final response = await query.order('created_at', ascending: true);
      return response;
    } catch (error) {
      print("Error fetching orders: $error");
      return [];
    }
  }

  // Fetch Count of Orders for Each Status
  Future<Map<String, int>> fetchOrderCounts() async {
    try {
      final response = await supabase
          .from('orders')
          .select('status');

      if (response == null || response.isEmpty) {
        return {};
      }

      // Count orders for each status
      final counts = <String, int>{};
      for (final order in response) {
        final status = order['status'] as String;
        counts[status] = (counts[status] ?? 0) + 1;
      }

      return counts;
    } catch (error) {
      print("Error fetching order counts: $error");
      return {};
    }
  }

  // Fetch Order Items for a Specific Order
  Future<List<Map<String, dynamic>>> fetchOrderItems(String orderId) async {
    try {
      final response = await supabase
          .from('order_items')
          .select('quantity, selected_size, product_id') // Include product_id
          .eq('order_id', orderId); // Filter by order_id

      print("Fetched order items: $response"); // Debug log
      return response;
    } catch (error) {
      print("Error fetching order items: $error");
      return [];
    }
  }

  // Fetch Product Details from Products Table
  Future<Map<String, dynamic>?> fetchProductDetails(String productId) async {
    try {
      print("Fetching product details for productId: $productId"); // Debug log

      final response = await supabase
          .from('products')
          .select('name, images') // Fetch name and images
          .eq('product_id', productId) // Use 'product_id' as per your schema
          .maybeSingle(); // Use maybeSingle() to handle no rows

      if (response == null) {
        print("No product found for productId: $productId"); // Debug log
        return null;
      }

      print("Fetched product details: $response"); // Debug log

      // Extract the first image URL from the images list
      final images = response['images'] as List<dynamic>?;
      final imageUrl = images != null && images.isNotEmpty ? images[0] as String? : null;

      return {
        'name': response['name'] as String?,
        'imageUrl': imageUrl, // Return the first image URL
      };
    } catch (error) {
      print("Error fetching product details: $error"); // Debug log
      return null;
    }
  }

  // Update Order Status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      print("Updating order $orderId to status: $newStatus"); // Debug statement

      // Update the order status in Supabase
      final response = await supabase
          .from('orders')
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('order_id', orderId); // Use 'order_id' as per your schema

      print("Update response: $response"); // Debug statement

      // Refresh the UI
      setState(() {});
    } catch (error) {
      print("Error updating order: $error"); // Debug statement
    }
  }

  // Delete Order
  Future<void> deleteOrder(String orderId) async {
    try {
      await supabase.from('orders').delete().eq('order_id', orderId);
      setState(() {}); // Refresh UI
    } catch (error) {
      print("Error deleting order: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F0A38),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: FutureBuilder(
                  future: fetchOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Orders Found."));
                    }

                    List<Map<String, dynamic>> orders = snapshot.data as List<Map<String, dynamic>>;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderItem(orders[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ORDERS',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      '0 Actions needed',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    );
                  } else {
                    // Count the number of orders in the "All" section
                    int orderCount = snapshot.data!.length;
                    return Text(
                      '$orderCount Actions needed',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  }
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "95% On-time",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return FutureBuilder<Map<String, int>>(
      future: fetchOrderCounts(),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {};

        return Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 15),
              _buildTabButton('All', Icons.grid_view, counts['All'] ?? 0),
              _buildTabButton('Unpaid', Icons.payment, counts['Unpaid'] ?? 0),
              _buildTabButton('In Transit', Icons.inventory_2_outlined, counts['In Transit'] ?? 0),
              _buildTabButton('To Ship', Icons.local_shipping_outlined, counts['To Ship'] ?? 0),
              const SizedBox(width: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String label, IconData icon, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: selectedTab == label ? Colors.white : const Color(0xFF3B2653),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: selectedTab == label ? Colors.black : Colors.white, size: 18),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: selectedTab == label ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
            if (count > 0) ...[
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
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
  String orderId = order['order_id'];
  String status = order['status']; // Get the order status

  // Placeholder for time duration (replace with actual logic if available)
  String timeDuration = "1h 20m 02s left"; // Example time duration

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Box and Time Duration
        Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchOrderItems(orderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                } else {
                  final orderItem = snapshot.data!.first;
                  final productId = orderItem['product_id'] as String;

                  return FutureBuilder<Map<String, dynamic>?>(
                    future: fetchProductDetails(productId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      } else {
                        final productDetails = snapshot.data!;
                        final imageUrl = productDetails['imageUrl'] as String?;

                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 5),
            // Time Duration with Refresh Icon
            Row(
              children: [
                const Icon(Icons.refresh, color: Colors.red, size: 16), // Double arrow refresh icon
                const SizedBox(width: 4),
                Text(
                  timeDuration,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name and Label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchOrderItems(orderId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          "Loading Product Name...",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(
                          "Unknown Product",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        );
                      } else {
                        final orderItem = snapshot.data!.first;
                        final productId = orderItem['product_id'] as String;

                        return FutureBuilder<Map<String, dynamic>?>(
                          future: fetchProductDetails(productId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text(
                                "Loading Product Name...",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return const Text(
                                "Unknown Product",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            } else {
                              final productDetails = snapshot.data!;
                              final productName = productDetails['name'] as String;

                              return Text(
                                productName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  // Display Label based on Order Status
                  if (status == 'Unpaid') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "To Confirm",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ] else if (status == 'In Transit') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "To Pack",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ] else if (status == 'To Ship') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "To Ship",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              // Order ID
              Text(
                "Order #${orderId.substring(0, 6)}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 5),
              // Fetch and Display Size and Qty
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchOrderItems(orderId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      "Loading Size and Qty...",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      "Size: N/A | Qty: N/A",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  } else {
                    // Display Size and Qty for the first item (or loop for multiple items)
                    final orderItem = snapshot.data!.first;
                    final size = orderItem['selected_size'].toString();
                    final capitalizedSize = size.isNotEmpty
                        ? size[0].toUpperCase() // Show only the first letter
                        : size;

                    return Row(
                      children: [
                        Text(
                          "Size: $capitalizedSize | ",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          "Qty: ${orderItem['quantity']}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1F0A38), // Dark blue circle
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              // Buttons for Unpaid Orders
              if (status == 'Unpaid') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        await deleteOrder(orderId);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await updateOrderStatus(orderId, 'In Transit');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1F0A38)),
                      child: const Text('Confirm Order', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ]
              // Buttons for In Transit Orders
              else if (status == 'In Transit') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await updateOrderStatus(orderId, 'To Ship');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1F0A38)),
                      child: const Text('Make as Packed', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ]
              // Buttons for To Ship Orders
              else if (status == 'To Ship') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await updateOrderStatus(orderId, 'Delivered');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1F0A38)),
                      child: const Text('Mark as Shipped', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
}