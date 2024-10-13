import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'models/product.dart';
import 'providers/product_provider.dart';

class ProductScannerPage extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _scanBarcode(BuildContext context) async {
    var result = await BarcodeScanner.scan();
    if (result.rawContent.isNotEmpty) {
      var productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      var product = productProvider.getProductByBarcode(result.rawContent);
      if (product != null) {
        _showProductDetails(context, product);
      } else {
        _showAddProductForm(context, result.rawContent);
      }
    }
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(product.imagePath)),
            Text('Buy Price: \$${product.buyPrice}'),
            Text('Sell Price: \$${product.sellPrice}'),
            Text('Stock: ${product.stock}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddProductForm(BuildContext context, String barcode) {
    TextEditingController nameController = TextEditingController();
    TextEditingController buyPriceController = TextEditingController();
    TextEditingController sellPriceController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name')),
            TextField(
                controller: buyPriceController,
                decoration: InputDecoration(labelText: 'Buy Price'),
                keyboardType: TextInputType.number),
            TextField(
                controller: sellPriceController,
                decoration: InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number),
            TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number),
            TextButton(
              onPressed: () async {
                pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
              },
              child: Text('Pick Image'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  buyPriceController.text.isNotEmpty &&
                  sellPriceController.text.isNotEmpty &&
                  stockController.text.isNotEmpty &&
                  pickedImage != null) {
                var newProduct = Product(
                  name: nameController.text,
                  buyPrice: double.parse(buyPriceController.text),
                  sellPrice: double.parse(sellPriceController.text),
                  imagePath: pickedImage!.path,
                  barcode: barcode,
                  stock: int.parse(stockController.text),
                );

                Provider.of<ProductProvider>(context, listen: false)
                    .addProduct(newProduct);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _scanBarcode(context),
          child: Text('Scan Barcode'),
        ),
      ),
    );
  }
}
