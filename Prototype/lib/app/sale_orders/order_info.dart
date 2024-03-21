import "package:flutter/material.dart";
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToOrderDetail(BuildContext context, SalesOrder item) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ItemDetailScreen(item: item),
    ),
  );
}

class ItemDetailScreen extends StatelessWidget {
  final SalesOrder item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Order Details', currentData: item, editType: EditType.salesOrder),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Order ID', item.orderID.toString()),
              _buildDetailRow('Customer', item.customerName),
              _buildDetailRow('Customer ID', item.customerID.toString()),
              _buildDetailRow('Product', item.productName),
              _buildDetailRow('Product ID', item.productID.toString()),
              _buildDetailRow('Order Date', item.orderDate),
              _buildDetailRow('Quantity', item.quantity.toString()),
              _buildDetailRow('Unit Price', '\$${item.unitPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Total Price', '\$${item.totalPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Status', item.orderStatus),
              _buildDetailRow('Employee', item.employee),
              _buildDetailRow('Employee ID', item.employeeID),
            ],
          ),
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
