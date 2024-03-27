import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToProductDetail(BuildContext context, ProductItem product) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
}

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  ProductItem product;
  ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final productController = Get.put(ProductController());
  void updateData(){
    setState(() {
      widget.product = productController.currentProductInfo.value!;
    });
  }
  @override
  Widget build(BuildContext context) {
    productController.updateEditData.value = updateData;
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Product Info', currentData: widget.product, editType: EditType.product),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Product ID', widget.product.productID.toString(), context),
            _buildDetailRow('Product Name', widget.product.productName, context),
            _buildDetailRow('Unit Price', '\$${widget.product.unitPrice.toStringAsFixed(2)}', context),
            _buildDetailRow('Selling Price', '\$${widget.product.sellingPrice.toStringAsFixed(2)}', context),
            _buildDetailRow('Quantity', widget.product.quantity.toString(), context),
            _buildDetailRow('Safety Quantity', widget.product.criticalLvl.toString(), context),
            _buildDetailRow('Markup', widget.product.markup.toString(), context),
            _buildDetailRow('Margin', widget.product.margin.toString(), context),
            _buildDetailRow('Status', widget.product.status, context),
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