import 'dart:convert';

class ProductModel {
  final String productId;
  final String shopId;
  final String name;
  final String description;
  final String category;
  final List<String> images;
  final double price;
  final int stock;
  final int likes;
  final int ordersCount;
  final String? sizeChart;
  final Map<String, dynamic>? sizeMeasurements;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.productId,
    required this.shopId,
    required this.name,
    required this.description,
    required this.category,
    required this.images,
    required this.price,
    required this.stock,
    required this.likes,
    required this.ordersCount,
    this.sizeChart,
    this.sizeMeasurements,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'],
      shopId: json['shop_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      likes: json['likes'],
      ordersCount: json['orders_count'],
      sizeChart: json['size_chart'],
      sizeMeasurements: json['size_measurements'] != null
          ? Map<String, dynamic>.from(json['size_measurements'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'shop_id': shopId,
      'name': name,
      'description': description,
      'category': category,
      'images': images,
      'price': price,
      'stock': stock,
      'likes': likes,
      'orders_count': ordersCount,
      'size_chart': sizeChart,
      'size_measurements': sizeMeasurements,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
