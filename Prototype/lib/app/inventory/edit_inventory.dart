// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/inventory/get_inventory.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class EditInventory extends StatefulWidget {
  final InventoryItem inventoryData;
  const EditInventory({super.key, required this.inventoryData});

  @override
  EditInventoryState createState() => EditInventoryState();
}

class EditInventoryState extends State<EditInventory> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _criticalLevelController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final inventoryController = Get.put(InventoryController());
  @override
  void initState() {
    super.initState();
    _itemNameController.text = widget.inventoryData.itemName;
    _categoryController.text = widget.inventoryData.category;
    _quantityController.text = widget.inventoryData.quantity.toString();
    _unitPriceController.text = widget.inventoryData.unitPrice.toStringAsFixed(2).toString();
    _criticalLevelController.text = widget.inventoryData.criticalLvl.toString();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _criticalLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Edit Purchase', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(
              Icons.delete,
              size: 24.0,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildTextField(controller: _itemNameController, labelText: 'Item Name'),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Item Category',  
                  options: getInventoryCategoryList(), 
                  onChanged: (value){_categoryController.text = value!;},
                  data: _categoryController.text,
                  defaultSelected: true,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _quantityController, 
                  labelText: 'Quantity', 
                  onChanged: (value) {},
                  floatData: false,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _unitPriceController, 
                  labelText: 'Unit Price', 
                  onChanged: (value) {},
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _criticalLevelController, 
                  labelText: 'Critical Level',  
                  onChanged: (value) {},
                  floatData: false,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        side: const BorderSide(color: Colors.black),
                        shape: const RoundedRectangleBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 15.0)
                      ),
                      onPressed: () async {
                      String? itemName = validateTextField(_itemNameController.text);
                      String? category = validateTextField(_categoryController.text);
                      String? quantity = validateTextField(_quantityController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? criticalLevel = validateTextField(_criticalLevelController.text);
                      if (itemName == null
                        || category == null
                        || quantity == null
                        || unitPrice == null
                        || criticalLevel == null) {
                          // Display validation error messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please fill in all the required fields.'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {                
                          final response = await requestUtil.updateInventory(
                            widget.inventoryData.itemID, itemName, category, unitPrice, quantity, criticalLevel
                          );
                          
                          if (response.statusCode == 200) {
                            Function? update = inventoryController.updateData.value;
                            Function? updateEdit = inventoryController.updateEditData.value;
                            inventoryController.updateInventoryInfo(InventoryItem(itemID: widget.inventoryData.itemID, itemName: itemName, category: category, quantity: int.parse(quantity), unitPrice: double.parse(unitPrice), totalPrice: double.parse(unitPrice) * double.parse(quantity), criticalLvl: int.parse(criticalLevel), status: widget.inventoryData.status));
                            inventoryController.clearInventories();
                            inventoryController.getInventories();
                            update!();
                            updateEdit!();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Inventory item edited successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Display an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Inventory item edit failed'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('DONE')
                    ),
                  ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Handle the deletion logic here
                // You can call a function to perform the deletion or any other action
                // For now, just close the dialog
                final response = await requestUtil.deleteInventory(widget.inventoryData.itemID);
                
                if (response.statusCode == 200) {
                  Function? update = inventoryController.updateData.value;
                  inventoryController.clearInventories();
                  inventoryController.getInventories();
                  update!();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inventory deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Display an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Delete Inventory failed'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}