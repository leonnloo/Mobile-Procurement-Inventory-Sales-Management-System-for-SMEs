// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prototype/app/inventory/get_inventory.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';

class StockInOutInventory extends StatefulWidget {
  const StockInOutInventory({super.key});

  @override
  StockInOutInventoryState createState() => StockInOutInventoryState();
}

class StockInOutInventoryState extends State<StockInOutInventory> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();

  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Stock In/Out Inventory'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Stock In', style: TextStyle(fontSize: 24.0),),
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Item',  
                  options: getInventoryItemList(), 
                  onChanged: (value){_itemNameController.text = value!;},
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _quantityController, 
                  labelText: 'Quantity', 
                  onChanged: (value) {},
                  floatData: false,
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
                      String? quantity = validateTextField(_quantityController.text);
                      if (itemName == null
                        || quantity == null) {
                        // Display validation error messages
                        _formKey.currentState?.validate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the required fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.stockInInventory(
                          itemName, quantity
                        );
                        
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock In successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock In failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('DONE')
                  ),
                ),
                // -----------------------------------------------------------------
                const SizedBox(height: 30.0),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Stock Out', style: TextStyle(fontSize: 24.0),),
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Item',  
                  options: getInventoryItemList(), 
                  onChanged: (value){_itemNameController.text = value!;},
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _quantityController, 
                  labelText: 'Quantity', 
                  onChanged: (value) {},
                  floatData: false,
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
                      String? quantity = validateTextField(_quantityController.text);
                      if (itemName == null
                        || quantity == null) {
                        // Display validation error messages
                        _formKey.currentState?.validate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the required fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.stockOutInventory(
                          itemName, quantity
                        );
                        
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock Out successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock Out failed'),
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