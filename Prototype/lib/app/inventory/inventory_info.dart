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
            _buildDetailRow('Item ID', item.itemID.toString(), context),
            _buildDetailRow('Item Name', item.itemName, context),
            _buildDetailRow('Category', item.category, context),
            _buildDetailRow('Quantity', item.quantity.toString(), context),
            _buildDetailRow('Unit Price', '\$${item.unitPrice.toStringAsFixed(2).toString()}', context),
            _buildDetailRow('Total Price', '\$${item.totalPrice.toStringAsFixed(2).toString()}', context),
            _buildDetailRow('Status', item.status, context),
            _buildDetailRow('Critical Level', item.criticalLvl.toString(), context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
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
