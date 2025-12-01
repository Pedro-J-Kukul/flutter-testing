/// Sale model for tracking sales transactions
class Sale {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final DateTime date;
  final String cashierId;

  Sale({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.date,
    required this.cashierId,
  });

  /// Create a copy of this sale with updated fields
  Sale copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalAmount,
    DateTime? date,
    String? cashierId,
  }) {
    return Sale(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      date: date ?? this.date,
      cashierId: cashierId ?? this.cashierId,
    );
  }
}
