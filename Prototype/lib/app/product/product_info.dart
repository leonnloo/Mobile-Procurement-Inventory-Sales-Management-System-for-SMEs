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
            _buildDetailRow('Product ID', product.productID.toString(), context),
            _buildDetailRow('Product Name', product.productName, context),
            _buildDetailRow('Unit Price', '\$${product.unitPrice.toStringAsFixed(2).toString()}', context),
            _buildDetailRow('Selling Price', '\$${product.sellingPrice.toStringAsFixed(2).toString()}', context),
            _buildDetailRow('Quantity', product.quantity.toString(), context),
            _buildDetailRow('Safety Quantity', product.criticalLvl.toString(), context),
            _buildDetailRow('Markup', product.markup.toString(), context),
            _buildDetailRow('Margin', product.margin.toString(), context),
            _buildDetailRow('Status', product.status, context),
            // Add more details based on your product data model
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          Text(value, style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}