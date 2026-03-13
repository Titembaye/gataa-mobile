class PriceModel {
  final int id;
  final String productName;
  final String categoryName;
  final double price;
  final String unit;
  final double variation;
  final String marketName;
  final String updatedAt;

  const PriceModel({
    required this.id,
    required this.productName,
    required this.categoryName,
    required this.price,
    required this.unit,
    required this.variation,
    required this.marketName,
    required this.updatedAt,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id'],
      productName: json['product_name'],
      categoryName: json['category_name'],
      price: (json['price'] as num).toDouble(),
      unit: json['unit'],
      variation: (json['variation'] as num).toDouble(),
      marketName: json['market_name'],
      updatedAt: json['updated_at'],
    );
  }
}