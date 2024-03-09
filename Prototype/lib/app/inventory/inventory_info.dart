import "package:flutter/material.dart";
import 'package:prototype/models/inventory_model.dart';

void navigateToItemDetail(BuildContext context, InventoryItem item) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ItemDetailScreen(item: item),
    ),
  );
}

class ItemDetailScreen extends StatelessWidget {
  final InventoryItem item;

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
            _buildDetailRow('Item ID', item.itemID.toString()),
            _buildDetailRow('Item Name', item.itemName),
            _buildDetailRow('Category', item.category),
            _buildDetailRow('Quantity', item.quantity.toString()),
            _buildDetailRow('Unit Price', '\$${item.unitPrice.toString()}'),
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
