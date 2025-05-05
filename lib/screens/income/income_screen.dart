import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiton_seller/services/shop_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class IncomeScreen extends StatefulWidget {
  final String shopId;

  const IncomeScreen({super.key, required this.shopId});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  late SupabaseService _supabaseService;
  bool _isLoading = true;
  List<Map<String, dynamic>> _pendingOrders = [];
  List<Map<String, dynamic>> _completedOrders = [];
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
      setState(() => _isLoading = true);

      print('Loading income data for shop ID: ${widget.shopId}');

      // Fetch pending orders (Unpaid and To Ship)
      final pendingResponse = await Supabase.instance.client
          .from('orders')
          .select()
          .eq('shop_id', widget.shopId)
          .or('status.eq.Unpaid,status.eq.To Ship')
          .order('created_at');

      print('Pending orders found: ${pendingResponse.length}');

      // Fetch completed orders (Delivered only)
      final completedResponse = await Supabase.instance.client
          .from('orders')
          .select()
          .eq('shop_id', widget.shopId)
          .eq('status', 'Delivered')
          .order('created_at');

      print('Completed orders found: ${completedResponse.length}');

      // Calculate total balance from completed orders
      double totalBalance = 0;
      for (var order in completedResponse) {
        final price = order['total_price'];
        print('Order price: $price (${price.runtimeType})');
        if (price != null) {
          totalBalance += double.parse(price.toString());
        }
      }

      print('Calculated total balance: $totalBalance');

      // Calculate monthly growth
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, now.day);

      double currentMonthTotal = 0;
      double lastMonthTotal = 0;

      for (var order in completedResponse) {
        final orderDate = DateTime.parse(order['created_at']);
        final price =
            order['total_price'] != null
                ? double.parse(order['total_price'].toString())
                : 0.0;

        if (orderDate.month == now.month && orderDate.year == now.year) {
          currentMonthTotal += price;
        } else if (orderDate.month == lastMonth.month &&
            orderDate.year == lastMonth.year) {
          lastMonthTotal += price;
        }
      }

      print('Current month total: $currentMonthTotal');
      print('Last month total: $lastMonthTotal');

      // Calculate monthly growth percentage
      double monthlyGrowth = 0;
      if (lastMonthTotal > 0) {
        monthlyGrowth =
            ((currentMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
      }

      print('Calculated monthly growth: $monthlyGrowth%');

      // Calculate success rate (Delivered orders vs total orders)
      final totalOrders = pendingResponse.length + completedResponse.length;
      final successRate =
          totalOrders > 0 ? (completedResponse.length / totalOrders) * 100 : 0;

      print('Calculated success rate: $successRate%');

      if (mounted) {
        setState(() {
          _pendingOrders = List<Map<String, dynamic>>.from(pendingResponse);
          _completedOrders = List<Map<String, dynamic>>.from(completedResponse);
          _incomeStats = {
            'totalBalance': totalBalance,
            'monthlyGrowth': monthlyGrowth,
            'successRate': successRate,
          };
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error loading income data: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading income data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generateAndDownloadReport() async {
    try {
      setState(() => _isLoading = true);

      // Create PDF document
      final pdf = pw.Document();

      // Add title page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Income Report',
                    style: pw.TextStyle(fontSize: 24),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Generated on: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total Balance: Rs ${NumberFormat('#,##0.00').format(_incomeStats['totalBalance'])}',
                ),
                pw.Text(
                  'Monthly Growth: ${_incomeStats['monthlyGrowth'].toStringAsFixed(1)}%',
                ),
                pw.Text(
                  'Success Rate: ${_incomeStats['successRate'].toStringAsFixed(1)}%',
                ),
                pw.SizedBox(height: 30),

                // Pending Orders Section
                pw.Header(level: 1, child: pw.Text('Pending Orders')),
                pw.Table.fromTextArray(
                  headers: ['Order ID', 'Date', 'Status', 'Amount'],
                  data:
                      _pendingOrders
                          .map(
                            (order) => [
                              order['order_id'].toString().substring(0, 8),
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(DateTime.parse(order['created_at'])),
                              order['status'],
                              'Rs ${NumberFormat('#,##0.00').format(order['total_price'])}',
                            ],
                          )
                          .toList(),
                ),
                pw.SizedBox(height: 20),

                // Completed Orders Section
                pw.Header(level: 1, child: pw.Text('Completed Orders')),
                pw.Table.fromTextArray(
                  headers: ['Order ID', 'Date', 'Status', 'Amount'],
                  data:
                      _completedOrders
                          .map(
                            (order) => [
                              order['order_id'].toString().substring(0, 8),
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(DateTime.parse(order['created_at'])),
                              order['status'],
                              'Rs ${NumberFormat('#,##0.00').format(order['total_price'])}',
                            ],
                          )
                          .toList(),
                ),
              ],
            );
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      final fileName =
          'income_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

      if (kIsWeb) {
        // Handle web platform
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement()
              ..href = url
              ..style.display = 'none'
              ..download = fileName;
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        // Handle mobile/desktop platforms
        if (Platform.isAndroid || Platform.isIOS) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception(
              'Storage permission is required to download the report',
            );
          }
        }

        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(pdfBytes);
        await OpenFile.open(file.path);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error generating report: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B0331),
      body: SafeArea(
        child:
            _isLoading
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
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Balance Card with working download button
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
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rs ${NumberFormat('#,##0.00').format(_incomeStats['totalBalance'])}',
                                      style: const TextStyle(
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
                                            onPressed:
                                                _generateAndDownloadReport,
                                          ),
                                          const Text(
                                            'Report',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Monthly Growth',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '${_incomeStats['monthlyGrowth'].toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            _incomeStats['monthlyGrowth'] >= 0
                                                ? Icons.trending_up
                                                : Icons.trending_down,
                                            color: Colors.white,
                                            size: 16,
                                          ),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Success Rate',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '${_incomeStats['successRate'].toStringAsFixed(1)}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.pie_chart,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                          children: [
                            _TransactionSection(
                              title: 'Pending & To Ship',
                              count: '${_pendingOrders.length} transactions',
                              transactions:
                                  _pendingOrders
                                      .map(
                                        (order) => _Transaction(
                                          orderNumber: order['order_id']
                                              .toString()
                                              .substring(0, 8),
                                          date: DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(
                                            DateTime.parse(order['created_at']),
                                          ),
                                          amount:
                                              'Rs ${NumberFormat('#,##0.00').format(order['total_price'])}',
                                          isPending: true,
                                          status: order['status'],
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 20),
                            _TransactionSection(
                              title: 'Delivered',
                              count: '${_completedOrders.length} transactions',
                              transactions:
                                  _completedOrders
                                      .map(
                                        (order) => _Transaction(
                                          orderNumber: order['order_id']
                                              .toString()
                                              .substring(0, 8),
                                          date: DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(
                                            DateTime.parse(order['created_at']),
                                          ),
                                          amount:
                                              'Rs ${NumberFormat('#,##0.00').format(order['total_price'])}',
                                          isPending: false,
                                          status: order['status'],
                                        ),
                                      )
                                      .toList(),
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              count,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
  final String status;

  const _Transaction({
    required this.orderNumber,
    required this.date,
    required this.amount,
    required this.isPending,
    required this.status,
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
              color: _getStatusColor(status),
              shape: BoxShape.circle,
            ),
            child: Icon(_getStatusIcon(status), color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #$orderNumber',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                status,
                style: TextStyle(color: _getStatusColor(status), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Unpaid':
        return Colors.red;
      case 'To Ship':
        return Colors.orange;
      case 'In Transit':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Unpaid':
        return Icons.payment;
      case 'To Ship':
        return Icons.local_shipping_outlined;
      case 'In Transit':
        return Icons.local_shipping;
      case 'Delivered':
        return Icons.check;
      default:
        return Icons.help_outline;
    }
  }
}
