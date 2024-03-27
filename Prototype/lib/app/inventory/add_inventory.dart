// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/inventory/get_inventory.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key, this.updateData});
  final Function? updateData;
  @override
  AddInventoryScreenState createState() => AddInventoryScreenState();
}

class AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();
  final inventoryController = Get.put(InventoryController());

  late TextEditingController _itemNameController;
  late TextEditingController _categoryController;
  late TextEditingController _unitPriceController;
  late TextEditingController _criticalLevelController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _categoryController = TextEditingController();
    _unitPriceController = TextEditingController();
    _criticalLevelController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _itemNameController.dispose();
    _categoryController.dispose();
    _unitPriceController.dispose();
    _criticalLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Add New Inventory'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildTextField(controller: _itemNameController, labelText: 'Item Name'),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Item Category',  
                  options: getInventoryCategoryList(), 
                  onChanged: (value){_categoryController.text = value!;},
                  defaultSelected: false,
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
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? criticalLevel = validateTextField(_criticalLevelController.text);
                      if (itemName == null
                        || category == null
                        || unitPrice == null
                        || criticalLevel == null) {
                        // Display validation error messages
                        _formKey.currentState?.validate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please fill in all the required fields.'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.newInventory(
                          itemName, category, unitPrice, criticalLevel
                        );
                        
                        if (response.statusCode == 200) {
                          Function? update = inventoryController.updateData.value;
                          inventoryController.clearInventories();
                          inventoryController.getInventories();
                          update!();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inventory added successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Inventory added failed'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('DONE')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}