class Income {
  final String releaseId;
  final String shopId;
  final String orderId;
  final double amount;
  final String releaseStatus;
  final DateTime releaseDate;
  final DateTime createdAt;

  Income({
    required this.releaseId,
    required this.shopId,
    required this.orderId,
    required this.amount,
    required this.releaseStatus,
    required this.releaseDate,
    required this.createdAt,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      releaseId: json['release_id'],
      shopId: json['shop_id'],
      orderId: json['order_id'],
      amount: json['amount'],
      releaseStatus: json['release_status'],
      releaseDate: DateTime.parse(json['release_date']),
      createdAt: DateTime.parse(json['created_at']),
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
