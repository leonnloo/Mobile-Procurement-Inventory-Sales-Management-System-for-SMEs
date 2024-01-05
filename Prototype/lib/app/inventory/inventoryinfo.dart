import "package:flutter/material.dart";
import 'package:prototype/models/inventorydata.dart';

void navigateToItemDetail(BuildContext context, InventoryItem item) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ItemDetailScreen(item: item),
    ),
  );
}

class ItemDetailScreen extends StatelessWidget {
  final InventoryItem item;

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Item ID', item.itemID.toString()),
            _buildDetailRow('Item Name', item.itemName ?? 'N/A'),
            _buildDetailRow('Category', item.category ?? 'N/A'),
            _buildDetailRow('Quantity', item.quantity?.toString() ?? 'N/A'),
            _buildDetailRow('Unit Price', '\$${item.unitPrice.toString()}'),
            _buildDetailRow('Total Price', '\$${item.totalPrice.toString()}'),
            _buildDetailRow('Status', item.status ?? 'N/A'),
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
          Text(label, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}
