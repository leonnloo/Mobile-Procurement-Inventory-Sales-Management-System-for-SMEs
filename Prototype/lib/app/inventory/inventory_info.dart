import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToItemDetail(BuildContext context, InventoryItem item) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ItemDetailScreen(item: item),
    ),
  );
}

// ignore: must_be_immutable
class ItemDetailScreen extends StatefulWidget {
  InventoryItem item;
  ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final inventoryController = Get.put(InventoryController());

  void updateData(){
    setState(() {
      widget.item = inventoryController.currentInventoryInfo.value!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Item Details', currentData: widget.item, editType: EditType.inventory),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Item ID', widget.item.itemID.toString(), context),
            _buildDetailRow('Item Name', widget.item.itemName, context),
            _buildDetailRow('Category', widget.item.category, context),
            _buildDetailRow('Quantity', widget.item.quantity.toString(), context),
            _buildDetailRow('Unit Price', '\$${widget.item.unitPrice.toStringAsFixed(2).toString()}', context),
            _buildDetailRow('Total Price', '\$${widget.item.totalPrice.toStringAsFixed(2).toString()}', context),
            _buildDetailRow('Status', widget.item.status, context),
            _buildDetailRow('Critical Level', widget.item.criticalLvl.toString(), context),
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
