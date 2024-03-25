import "package:flutter/material.dart";
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToItemDetail(BuildContext context, InventoryItem item, Function updateData) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ItemDetailScreen(item: item, updateData: updateData),
    ),
  );
}

class ItemDetailScreen extends StatelessWidget {
  final InventoryItem item;
  final Function updateData;
  const ItemDetailScreen({super.key, required this.item, required this.updateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Item Details', currentData: item, editType: EditType.inventory, updateData: updateData,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Item ID', item.itemID.toString()),
            _buildDetailRow('Item Name', item.itemName),
            _buildDetailRow('Category', item.category),
            _buildDetailRow('Quantity', item.quantity.toString()),
            _buildDetailRow('Unit Price', '\$${item.unitPrice.toStringAsFixed(2).toString()}'),
            _buildDetailRow('Total Price', '\$${item.totalPrice.toStringAsFixed(2).toString()}'),
            _buildDetailRow('Status', item.status),
            _buildDetailRow('Critical Level', item.criticalLvl.toString()),
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
