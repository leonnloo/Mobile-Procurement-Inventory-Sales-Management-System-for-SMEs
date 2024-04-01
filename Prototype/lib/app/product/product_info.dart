import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';
import 'package:prototype/widgets/info_details.dart';

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
    if (mounted) {
      setState(() {
        widget.product = productController.currentProductInfo.value!;
      });
    }
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
            buildDetailRow('Product ID', widget.product.productID.toString(), context),
            buildDetailRow('Product Name', widget.product.productName, context),
            buildDetailRow('Unit Price', '\$${widget.product.unitPrice.toStringAsFixed(2)}', context),
            buildDetailRow('Selling Price', '\$${widget.product.sellingPrice.toStringAsFixed(2)}', context),
            buildDetailRow('Quantity', widget.product.quantity.toString(), context),
            buildDetailRow('Safety Quantity', widget.product.criticalLvl.toString(), context),
            buildDetailRow('Markup', widget.product.markup.toString(), context),
            buildDetailRow('Margin', widget.product.margin.toString(), context),
            buildDetailRow('Status', widget.product.status, context),
            // Add more details based on your product data model
          ],
        ),
      ),
    );
  }
}