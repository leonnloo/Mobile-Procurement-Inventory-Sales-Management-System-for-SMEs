import 'package:flutter/material.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToProductDetail(BuildContext context, ProductItem product, Function updateData) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product, updateData: updateData),
    ),
  );
}

class ProductDetailScreen extends StatelessWidget {
  final ProductItem product;
  final Function updateData;
  const ProductDetailScreen({super.key, required this.product, required this.updateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Product Info', currentData: product, editType: EditType.product, updateData: updateData,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Product ID', product.productID.toString()),
            _buildDetailRow('Product Name', product.productName),
            _buildDetailRow('Unit Price', '\$${product.unitPrice.toStringAsFixed(2).toString()}'),
            _buildDetailRow('Selling Price', '\$${product.sellingPrice.toStringAsFixed(2).toString()}'),
            _buildDetailRow('Quantity', product.quantity.toString()),
            
            _buildDetailRow('Safety Quantity', product.criticalLvl.toString()),
            _buildDetailRow('Markup', product.markup.toString()),
            _buildDetailRow('Margin', product.margin.toString()),
            
            _buildDetailRow('Status', product.status),
            // Add more details based on your product data model
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}