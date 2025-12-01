/// Product model for inventory management
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
  });

  /// Create a copy of this product with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
