import 'package:flutter/material.dart';
import 'package:prototype/app/inventory/get_inventory.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  AddInventoryScreenState createState() => AddInventoryScreenState();
}

class AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();

  late TextEditingController _itemNameController;
  late TextEditingController _categoryController;
  late TextEditingController _unitPriceController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _categoryController = TextEditingController();
    _unitPriceController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _itemNameController.dispose();
    _categoryController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(currentTitle: 'Add New Inventory'),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 15.0)
                    ),
                    onPressed: () async {
                      String? itemName = validateTextField(_itemNameController.text);
                      String? category = validateTextField(_categoryController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      if (itemName == null
                        || category == null
                        || unitPrice == null) {
                        // Display validation error messages
                        _formKey.currentState?.validate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the required fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.newInventory(
                          itemName, category, unitPrice
                        );
                        
                        if (response.statusCode == 200) {
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
                            const SnackBar(
                              content: Text('Inventory added failed'),
                              backgroundColor: Colors.red,
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