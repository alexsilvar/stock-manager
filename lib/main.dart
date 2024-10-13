import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager/models/product.dart';
import 'package:stock_manager/product_scanner.dart';
import 'package:stock_manager/providers/product_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  // Open a box to store products
  await Hive.openBox<Product>('products');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventor.IO',
      home: ProductScannerPage(),
    );
  }
}
