import 'package:flutter/material.dart';
import 'package:prototype/models/productdata.dart';

void navigateToProductDetail(BuildContext context, Product product) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Product ID', product.productID.toString()),
            _buildDetailRow('Product Name', product.productName),
            _buildDetailRow('Unit Price', '\$${product.unitPrice.toString()}'),
            _buildDetailRow('Selling Price', '\$${product.sellingPrice.toString()}'),
            _buildDetailRow('Quantity', product.quantity.toString()),
            _buildDetailRow('Weight', product.weight.toString()),
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