import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class SalesScreen extends StatefulWidget {
  final String shopId;

  const SalesScreen({Key? key, required this.shopId}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _sales = [];
  Map<String, dynamic> _salesStats = {
    'totalSales': 0.0,
    'totalOrders': 0,
    'averageOrderValue': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    try {
      setState(() => _isLoading = true);

      // Fetch completed orders (Delivered status)
      final response = await _supabase
          .from('orders')
          .select()
          .eq('shop_id', widget.shopId)
          .eq('status', 'Delivered')
          .order('created_at', ascending: false);

      final orders = List<Map<String, dynamic>>.from(response);

      // Calculate sales statistics
      double totalSales = 0;
      for (var order in orders) {
        if (order['total_price'] != null) {
          totalSales += double.parse(order['total_price'].toString());
        }
      }

      setState(() {
        _sales = orders;
        _salesStats = {
          'totalSales': totalSales,
          'totalOrders': orders.length,
          'averageOrderValue': orders.isEmpty ? 0 : totalSales / orders.length,
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading sales data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading sales data: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top App Bar
          Container(
            width: double.infinity,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFF1A0038),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SALES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: const Text(
                            'Sales Overview',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sales Content
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: _loadSalesData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sales Statistics Cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Sales',
                                      'Rs ${NumberFormat('#,##0.00').format(_salesStats['totalSales'])}',
                                      Icons.monetization_on,
                                      Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      'Total Orders',
                                      _salesStats['totalOrders'].toString(),
                                      Icons.shopping_bag,
                                      Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildStatCard(
                                'Average Order Value',
                                'Rs ${NumberFormat('#,##0.00').format(_salesStats['averageOrderValue'])}',
                                Icons.analytics,
                                Colors.purple,
                              ),
                              const SizedBox(height: 24),

                              // Recent Sales List
                              const Text(
                                'Recent Sales',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _sales.isEmpty
                                  ? const Center(
                                    child: Text(
                                      'No sales data available',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _sales.length,
                                    itemBuilder: (context, index) {
                                      final sale = _sales[index];
                                      return Card(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFF1A0038),
                                            child: Icon(
                                              Icons.receipt,
                                              color: Colors.white,
                                            ),
                                          ),
                                          title: Text(
                                            'Order #${sale['order_id'].toString().substring(0, 8)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            DateFormat('MMM dd, yyyy').format(
                                              DateTime.parse(
                                                sale['created_at'],
                                              ),
                                            ),
                                          ),
                                          trailing: Text(
                                            'Rs ${NumberFormat('#,##0.00').format(double.parse(sale['total_price'].toString()))}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
