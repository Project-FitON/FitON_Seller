// lib/models/shop.dart
class Shop {
  final String id;
  final String name;
  final String nickname;
  final String phoneNumber;
  final String email;
  final String? profilePhoto;
  final String? coverPhoto;
  final bool cashOnDelivery;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop({
    required this.id,
    required this.name,
    required this.nickname,
    required this.phoneNumber,
    required this.email,
    this.profilePhoto,
    this.coverPhoto,
    required this.cashOnDelivery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['shop_id'],
      name: json['shop_name'],
      nickname: json['nickname'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      profilePhoto: json['profile_photo'],
      coverPhoto: json['cover_photo'],
      cashOnDelivery: json['cash_on_delivery'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}