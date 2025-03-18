// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shop_model.dart';

class SupabaseService {
  final SupabaseClient _supabaseClient;

  SupabaseService(this._supabaseClient);

  // Fetch current shop data
  Future<Shop?> getCurrentShop(String shopId) async {
    try {
      print('Fetching shop with ID: $shopId');
      
      if (shopId.isEmpty) {
        print('Error: Empty shop ID provided to getCurrentShop');
        return null;
      }
      
      final response = await _supabaseClient
          .from('shops')
          .select()
          .eq('shop_id', shopId)
          .single();

      print('Shop response: $response');
      
      if (response == null) {
        print('No shop found with ID: $shopId');
        return null;
      }
      
      final shop = Shop.fromJson(response);
      print('Shop parsed successfully: ${shop.name} (${shop.id})');
      return shop;
    } catch (e) {
      print('Error fetching shop data: $e');
      print('Error type: ${e.runtimeType}');
      
      // Try to get any shop as fallback
      try {
        print('Attempting to fetch any shop as fallback');
        final fallbackResponse = await _supabaseClient
            .from('shops')
            .select()
            .limit(1)
            .single();
            
        if (fallbackResponse != null) {
          final fallbackShop = Shop.fromJson(fallbackResponse);
          print('Using fallback shop: ${fallbackShop.name} (${fallbackShop.id})');
          return fallbackShop;
        }
      } catch (fallbackError) {
        print('Fallback shop fetch also failed: $fallbackError');
      }
      
      return null;
    }
  }

  // Fetch all shops
  Future<List<Shop>> getAllShops() async {
    try {
      final response = await _supabaseClient
          .from('shops')
          .select()
          .order('created_at', ascending: false);

      return (response as List).map((shop) => Shop.fromJson(shop)).toList();
    } catch (e) {
      print('Error fetching shops: $e');
      return [];
    }
  }

  // Generic method to fetch data from any table
  Future<List<Map<String, dynamic>>> fetchTableData(
    String tableName, {
    List<String>? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      final query = _supabaseClient
          .from(tableName)
          .select(select?.join(',') ?? '*');

      // Apply filters if provided
      if (filters != null) {
        for (final entry in filters.entries) {
          filters.forEach((key, value) => query.eq(key, value));
        }
      }

      // Apply ordering if provided
      if (orderBy != null) {
        query.order(orderBy, ascending: ascending);
      }

      // Apply limit if provided
      if (limit != null) {
        query.limit(limit);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching data from $tableName: $e');
      return [];
    }
  }

  // Fetch recent orders for a shop
  Future<List<Map<String, dynamic>>> getRecentOrders(String shopId, {int limit = 5}) async {
    try {
      print('Fetching orders for shop ID: $shopId');
      
      // Check if the shop ID is valid
      if (shopId.isEmpty) {
        print('Error: Empty shop ID provided to getRecentOrders');
        return _getDummyOrders();
      }
      
      // Get available tables
      final tables = await getTableNames();
      print('Available tables for orders: $tables');
      
      // Try to fetch from 'orders' table
      if (tables.contains('orders')) {
        try {
          print('Fetching from "orders" table');
          final response = await _supabaseClient
              .from('orders')
              .select('*')
              .eq('shop_id', shopId)
              .order('created_at', ascending: false)
              .limit(limit);
              
          print('Orders response: $response');
          if (response != null && response is List && response.isNotEmpty) {
            return List<Map<String, dynamic>>.from(response);
          }
        } catch (e) {
          print('Error fetching from "orders" table: $e');
        }
      }
      
      // If that fails, try a more generic approach with fetchTableData
      try {
        print('Trying generic fetchTableData approach for orders');
        final genericResponse = await fetchTableData(
          'orders',
          filters: {'shop_id': shopId},
          orderBy: 'created_at',
          ascending: false,
          limit: limit,
        );
        
        if (genericResponse.isNotEmpty) {
          return genericResponse;
        }
      } catch (e) {
        print('Error with generic fetchTableData approach for orders: $e');
      }
      
      // If all attempts fail, return dummy data
      print('All attempts to fetch orders failed, returning dummy data');
      return _getDummyOrders();
    } catch (e) {
      print('Error in getRecentOrders: $e');
      print('Error type: ${e.runtimeType}');
      return _getDummyOrders();
    }
  }

  // Fetch latest reviews for a shop
  Future<List<Map<String, dynamic>>> getLatestReviews(String shopId, {int limit = 5}) async {
    try {
      print('Fetching reviews for shop ID: $shopId');
      
      // Check if the shop ID is valid
      if (shopId.isEmpty) {
        print('Error: Empty shop ID provided to getLatestReviews');
        return _getDummyReviews();
      }
      
      // Get available tables
      final tables = await getTableNames();
      print('Available tables for reviews: $tables');
      
      // Try to fetch from 'reviews' table first (plural) if it exists
      if (tables.contains('reviews')) {
        try {
          print('Trying to fetch from "reviews" table');
          final reviewsResponse = await _supabaseClient
              .from('reviews')
              .select('*')
              .eq('shop_id', shopId)
              .order('created_at', ascending: false)
              .limit(limit);
              
          print('Reviews response from "reviews" table: $reviewsResponse');
          if (reviewsResponse != null && reviewsResponse is List && reviewsResponse.isNotEmpty) {
            return List<Map<String, dynamic>>.from(reviewsResponse);
          }
        } catch (e) {
          print('Error fetching from "reviews" table: $e');
        }
      }
      
      // If that fails, try 'review' table (singular) if it exists
      if (tables.contains('review')) {
        try {
          print('Trying to fetch from "review" table');
          final reviewResponse = await _supabaseClient
              .from('review')
              .select('*')
              .eq('shop_id', shopId)
              .order('created_at', ascending: false)
              .limit(limit);
              
          print('Reviews response from "review" table: $reviewResponse');
          if (reviewResponse != null && reviewResponse is List && reviewResponse.isNotEmpty) {
            return List<Map<String, dynamic>>.from(reviewResponse);
          }
        } catch (e) {
          print('Error fetching from "review" table: $e');
        }
      }
      
      // If both fail, try a more generic approach with fetchTableData
      for (final tableName in ['reviews', 'review']) {
        if (tables.contains(tableName)) {
          try {
            print('Trying generic fetchTableData approach with $tableName');
            final genericResponse = await fetchTableData(
              tableName,
              filters: {'shop_id': shopId},
              orderBy: 'created_at',
              ascending: false,
              limit: limit,
            );
            
            if (genericResponse.isNotEmpty) {
              return genericResponse;
            }
          } catch (e) {
            print('Error with generic fetchTableData approach for $tableName: $e');
          }
        }
      }
      
      // If all attempts fail, return dummy data
      print('All attempts to fetch reviews failed, returning dummy data');
      return _getDummyReviews();
    } catch (e) {
      print('Error in getLatestReviews: $e');
      print('Error type: ${e.runtimeType}');
      return _getDummyReviews();
    }
  }

  // Get shop statistics
  Future<Map<String, dynamic>> getShopStats(String shopId) async {
    try {
      print('Fetching statistics for shop ID: $shopId');
      
      // Get available tables
      final tables = await getTableNames();
      print('Available tables for stats: $tables');
      
      // Get orders count
      final ordersResponse = await _supabaseClient
          .from('orders')
          .select('*')
          .eq('shop_id', shopId);
      
      // Get reviews count - try both 'reviews' and 'review' tables
      List reviewsData = [];
      
      // Try 'reviews' table if it exists
      if (tables.contains('reviews')) {
        try {
          final reviewsResponse = await _supabaseClient
              .from('reviews')
              .select('*')
              .eq('shop_id', shopId);
          reviewsData = reviewsResponse;
          print('Found ${reviewsData.length} reviews in "reviews" table');
        } catch (e) {
          print('Error fetching from "reviews" table: $e');
        }
      }
      
      // If no reviews found, try 'review' table if it exists
      if (reviewsData.isEmpty && tables.contains('review')) {
        try {
          final reviewResponse = await _supabaseClient
              .from('review')
              .select('*')
              .eq('shop_id', shopId);
          reviewsData = reviewResponse;
          print('Found ${reviewsData.length} reviews in "review" table');
        } catch (e) {
          print('Error fetching from "review" table: $e');
        }
      }

      // Get last month's orders
      final lastMonthResponse = await _supabaseClient
          .from('orders')
          .select('*')
          .eq('shop_id', shopId)
          .gte('created_at', DateTime.now().subtract(const Duration(days: 30)).toIso8601String());

      // Get previous month's orders
      final previousMonthResponse = await _supabaseClient
          .from('orders')
          .select('*')
          .eq('shop_id', shopId)
          .gte('created_at', DateTime.now().subtract(const Duration(days: 60)).toIso8601String())
          .lt('created_at', DateTime.now().subtract(const Duration(days: 30)).toIso8601String());

      // Convert responses to lists and get counts
      final List ordersData = ordersResponse;
      final List lastMonthData = lastMonthResponse;
      final List previousMonthData = previousMonthResponse;

      final orderCount = ordersData.length;
      final reviewCount = reviewsData.length;
      final lastMonthOrderCount = lastMonthData.length;
      final previousMonthOrderCount = previousMonthData.length;

      // Calculate growth
      final orderGrowth = previousMonthOrderCount != 0
          ? ((lastMonthOrderCount - previousMonthOrderCount) / previousMonthOrderCount * 100).toStringAsFixed(1)
          : '0.0';

      print('Stats response: orderCount=$orderCount, reviewCount=$reviewCount, orderGrowth=$orderGrowth%');
      
      return {
        'orderCount': orderCount.toString(),
        'reviewCount': reviewCount.toString(),
        'orderGrowth': '$orderGrowth%',
      };
    } catch (e) {
      print('Error fetching shop statistics: $e');
      return {
        'orderCount': '0',
        'reviewCount': '0',
        'orderGrowth': '0.0%',
      };
    }
  }

  // Get current user's shop ID
  Future<String?> getCurrentUserShopId() async {
    try {
      // Get first shop from the shops table
      final response = await _supabaseClient
          .from('shops')
          .select()
          .limit(1)
          .single();

      print('Shop data response: $response');
      if (response == null) {
        print('No shops found in the database');
        return null;
      }

      // Try both 'id' and 'shop_id' fields
      final shopId = response['id'] ?? response['shop_id'];
      print('Using shop ID: $shopId');
      return shopId?.toString();
    } catch (e) {
      print('Error fetching shop ID: $e');
      return null;
    }
  }

  // Fetch products for a specific shop
  Future<List<Map<String, dynamic>>> getShopProducts({
    String? shopId,
    String? category,
    int? limit,
    int? offset,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      final currentShopId = shopId ?? await getCurrentUserShopId();
      if (currentShopId == null) {
        print('No shop ID found');
        return [];
      }

      print('Fetching products for shop ID: $currentShopId');
      
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('shop_id', currentShopId)
          .eq(category != null && category.toLowerCase() != 'all' ? 'category' : 'shop_id', category ?? currentShopId)
          .order(sortBy ?? 'created_at', ascending: ascending)
          .limit(limit ?? 50);

      print('Products response: $response');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching shop products: $e');
      return [];
    }
  }

  // Helper method to get dummy products for testing
  List<Map<String, dynamic>> _getDummyProducts() {
    return [
      {
        'id': '1',
        'name': 'Sport T-Shirt',
        'price': 29.99,
        'image_url': 'https://picsum.photos/200/300',
        'category': 'Sport',
        'is_featured': true,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'name': 'Office Shirt',
        'price': 49.99,
        'image_url': 'https://picsum.photos/200/300',
        'category': 'Office',
        'is_featured': false,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'name': 'Casual T-Shirt',
        'price': 19.99,
        'image_url': 'https://picsum.photos/200/300',
        'category': 'T-shirt',
        'is_featured': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
  }

  // Helper method to get dummy orders
  List<Map<String, dynamic>> _getDummyOrders() {
    return [
      {
        'id': '1',
        'order_number': '8234',
        'total': 1250.00,
        'status': 'pending',
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'buyers': {'name': 'John Doe'},
      },
      {
        'id': '2',
        'order_number': '8233',
        'total': 2450.00,
        'status': 'completed',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'buyers': {'name': 'Jane Smith'},
      },
      {
        'id': '3',
        'order_number': '8232',
        'total': 3150.00,
        'status': 'completed',
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'buyers': {'name': 'Mike Johnson'},
      },
    ];
  }

  // Helper method to get dummy reviews
  List<Map<String, dynamic>> _getDummyReviews() {
    return [
      {
        'id': '1',
        'rating': 5,
        'comment': 'Great product! Very satisfied with the quality.',
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'buyers': {'name': 'John Doe'},
      },
      {
        'id': '2',
        'rating': 4,
        'comment': 'Good product, fast delivery.',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'buyers': {'name': 'Jane Smith'},
      },
      {
        'id': '3',
        'rating': 5,
        'comment': 'Excellent service and product quality!',
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'buyers': {'name': 'Mike Johnson'},
      },
    ];
  }

  // Helper method to get actual table names from Supabase
  Future<List<String>> getTableNames() async {
    try {
      // This is a PostgreSQL function that lists all tables
      final response = await _supabaseClient.rpc('list_tables');
      if (response != null && response is List) {
        return List<String>.from(response.map((table) => table['table_name'].toString()));
      }
      return [];
    } catch (e) {
      print('Error getting table names: $e');
      // Fallback to common table names
      return ['shops', 'products', 'orders', 'reviews', 'review', 'buyers'];
    }
  }

  // Helper method to check if a table exists
  Future<bool> tableExists(String tableName) async {
    final tables = await getTableNames();
    return tables.contains(tableName);
  }
}