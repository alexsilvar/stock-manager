import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final Box<Product> _productBox = Hive.box<Product>('products');

  List<Product> get products => _productBox.values.toList();

  Product? getProductByBarcode(String barcode) {
    return _productBox.values
        .firstWhere((product) => product.barcode == barcode);
  }

  void addProduct(Product product) {
    _productBox.add(product);
    notifyListeners();
  }
}
