import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';
import 'package:prototype/widgets/info_details.dart';

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
    if (mounted) {
      setState(() {
        widget.item = inventoryController.currentInventoryInfo.value!;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    inventoryController.updateEditData.value = updateData;
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Item Details', currentData: widget.item, editType: EditType.inventory),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailRow('Item ID', widget.item.itemID.toString(), context),
            buildDetailRow('Item Name', widget.item.itemName, context),
            buildDetailRow('Category', widget.item.category, context),
            buildDetailRow('Quantity', widget.item.quantity.toString(), context),
            buildDetailRow('Unit Price', '\$${widget.item.unitPrice.toStringAsFixed(2).toString()}', context),
            buildDetailRow('Total Price', '\$${widget.item.totalPrice.toStringAsFixed(2).toString()}', context),
            buildDetailRow('Status', widget.item.status, context),
            buildDetailRow('Critical Level', widget.item.criticalLvl.toString(), context),
          ],
        ),
      ),
    );
  }
}
