class PaymentRelease {
  final String releaseId;
  final String shopId;
  final String orderId;
  final double amount;
  final String releaseStatus;
  final DateTime releaseDate;
  final DateTime createdAt;

  PaymentRelease({
    required this.releaseId,
    required this.shopId,
    required this.orderId,
    required this.amount,
    required this.releaseStatus,
    required this.releaseDate,
    required this.createdAt,
  });

  factory PaymentRelease.fromJson(Map<String, dynamic> json) {
    return PaymentRelease(
      releaseId: json['release_id'] as String,
      shopId: json['shop_id'] as String,
      orderId: json['order_id'] as String,
      amount: json['amount'] as double,
      releaseStatus: json['release_status'] as String,
      releaseDate: DateTime.parse(json['release_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'release_id': releaseId,
      'shop_id': shopId,
      'order_id': orderId,
      'amount': amount,
      'release_status': releaseStatus,
      'release_date': releaseDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
