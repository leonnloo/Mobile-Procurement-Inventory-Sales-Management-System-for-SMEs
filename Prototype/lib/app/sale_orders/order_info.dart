import "package:flutter/material.dart";
import 'package:prototype/models/order_model.dart';

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
      appBar: AppBar(
        title: const Text('Item Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Item ID', item.orderNo.toString()),
            _buildDetailRow('Item Name', item.date),
            _buildDetailRow('Category', item.customerID.toString()),
            _buildDetailRow('Unit Price', item.productID.toString()),
            _buildDetailRow('Quantity', item.quantity.toString()),
            _buildDetailRow('Total Price', '\$${item.totalPrice.toString()}'),
            _buildDetailRow('Status', item.status),
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
