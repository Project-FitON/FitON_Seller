import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton_seller/services/shop_service.dart';

class IncomeScreen extends StatefulWidget {
  final String shopId;

  const IncomeScreen({
    super.key,
    required this.shopId,
  });

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  late SupabaseService _supabaseService;
  bool _isLoading = true;
  Map<String, dynamic> _incomeStats = {
    'totalBalance': 0.0,
    'monthlyGrowth': 0.0,
    'successRate': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseService(Supabase.instance.client);
    _loadIncomeData();
  }

  Future<void> _loadIncomeData() async {
    try {
      // TODO: Implement income data fetching from Supabase
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading income data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0331),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'INCOME',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Balance Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Balance',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Rs 45,280.00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.download),
                                          iconSize: 20,
                                          color: Colors.white,
                                          onPressed: () {},
                                        ),
                                        const Text(
                                          'Report',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade900,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monthly Growth',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '+24%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.trending_up, color: Colors.white, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade900,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Success Rate',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '92%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.pie_chart, color: Colors.white, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Navigation Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_view_month_rounded),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.calendar_today_outlined),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                                const Text(
                                  'Monthly',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.history),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Transactions Section
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: const [
                          _TransactionSection(
                            title: 'Pending',
                            count: '3 transactions',
                            transactions: [
                              _Transaction(
                                orderNumber: '8234',
                                date: 'Jan 15, 2025',
                                amount: 'Rs 1,250.00',
                                isPending: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          _TransactionSection(
                            title: 'Released',
                            count: '12 transactions',
                            transactions: [
                              _Transaction(
                                orderNumber: '8233',
                                date: 'Jan 14, 2025',
                                amount: 'Rs 2,450.00',
                                isPending: false,
                              ),
                              _Transaction(
                                orderNumber: '8232',
                                date: 'Jan 13, 2025',
                                amount: 'Rs 3,150.00',
                                isPending: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TransactionSection extends StatelessWidget {
  final String title;
  final String count;
  final List<_Transaction> transactions;

  const _TransactionSection({
    required this.title,
    required this.count,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...transactions,
      ],
    );
  }
}

class _Transaction extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String amount;
  final bool isPending;

  const _Transaction({
    required this.orderNumber,
    required this.date,
    required this.amount,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPending ? Colors.orange : Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPending ? Icons.access_time : Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #$orderNumber',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isPending ? 'Pending' : 'Released',
                style: TextStyle(
                  color: isPending ? Colors.orange : Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}