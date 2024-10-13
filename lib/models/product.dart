import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double buyPrice;

  @HiveField(2)
  final double sellPrice;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  final String barcode;

  @HiveField(5)
  final int stock;

  Product({
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.imagePath,
    required this.barcode,
    required this.stock,
  });
}
