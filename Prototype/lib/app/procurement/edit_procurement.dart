// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/procurement/get_procurement.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class EditProcurement extends StatefulWidget {
  final PurchasingOrder procurementData;
  final Function updateData;
  const EditProcurement({super.key, required this.procurementData, required this.updateData});

  @override
  EditProcurementState createState() => EditProcurementState();
}

class EditProcurementState extends State<EditProcurement> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemTypeController = TextEditingController();
  final TextEditingController _itemIDController = TextEditingController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  late String type = 'Product';
  bool changeType = true;
  @override
  void initState() {
    super.initState();
    _itemNameController.text = widget.procurementData.itemName;
    _itemTypeController.text = widget.procurementData.itemType;
    _itemIDController.text = widget.procurementData.itemID;
    _supplierNameController.text = widget.procurementData.supplierName;
    _orderDateController.text = widget.procurementData.orderDate;
    _deliveryDateController.text = widget.procurementData.deliveryDate;
    _quantityController.text = widget.procurementData.quantity.toString();
    _unitPriceController.text = widget.procurementData.unitPrice.toStringAsFixed(2);
    _totalPriceController.text = widget.procurementData.totalPrice.toStringAsFixed(2);
    _statusController.text = widget.procurementData.status;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemTypeController.dispose();
    _itemIDController.dispose();
    _supplierNameController.dispose();
    _orderDateController.dispose();
    _deliveryDateController.dispose();
    _totalPriceController.dispose();
    _quantityController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              size: 30.0,
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
                DropdownTextField(
                  labelText: 'Type', 
                  options: getProcurementTypeList(), 
                  onChanged: (value){
                    _itemTypeController.text = value!;
                    setState(() {
                      type = value;
                      _itemNameController.clear();
                      changeType = false;
                  });},
                  defaultSelected: true,
                  data: _itemTypeController.text,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Item', 
                  options: getItemList(type), 
                  onChanged: (value){
                      _itemNameController.text = value!;
                      updateItemID(value, type,_itemIDController);
                      changeUnitPrice(type, _itemNameController.text, _unitPriceController, _quantityController, _totalPriceController);
                    },
                  defaultSelected: changeType,
                  data: _itemNameController.text,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Supplier', 
                  options: getSupplierList(), 
                  onChanged: (value){_supplierNameController.text = value!;},
                  defaultSelected: true,
                  data: _supplierNameController.text,
                ),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _orderDateController, labelText: 'Order Date', data: widget.procurementData.orderDate,),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _deliveryDateController, labelText: 'Delivery Date', data: widget.procurementData.deliveryDate,),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _quantityController, 
                  labelText: 'Quantity', 
                  onChanged: (value) {
                    updateTotalPrice(_unitPriceController, _quantityController, _totalPriceController);
                  },
                  floatData: false,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _unitPriceController, 
                  labelText: 'Unit Price', 
                  onChanged: (value) {
                    updateTotalPrice(_unitPriceController, _quantityController, _totalPriceController);
                  },
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _totalPriceController, labelText: 'Total Price', data: widget.procurementData.totalPrice,),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Status', 
                  options: getProcurementStatusList(), 
                  onChanged: (value){_statusController.text = value!;},
                  defaultSelected: true,
                  data: _statusController.text,
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
                      String? itemType = validateTextField(_itemTypeController.text);
                      String? itemID = validateTextField(_itemIDController.text);
                      String? supplierName = validateTextField(_supplierNameController.text);
                      String? orderDate= validateTextField(_orderDateController.text);
                      String? deliveryDate = validateTextField(_deliveryDateController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? totalPrice = validateTextField(_totalPriceController.text);
                      String? quantity = validateTextField(_quantityController.text);
                      String? status = validateTextField(_statusController.text);
                      if (itemName == null
                        || itemType == null
                        || itemID == null
                        || supplierName == null
                        || orderDate == null
                        || deliveryDate == null
                        || unitPrice == null
                        || totalPrice == null
                        || quantity == null
                        || status == null) {
                          // Display validation error messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please fill in all the required fields.'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {                
                          final response = await requestUtil.updateProcurement(
                            widget.procurementData.purchaseID, itemName, itemType, itemID, supplierName, orderDate, deliveryDate, unitPrice, totalPrice, quantity, status
                          );
                          
                          if (response.statusCode == 200) {
                            widget.updateData();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Purchase order edited successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Display an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Purchase edit failed: ${jsonDecode(response.body)['detail']}'),
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
                final response = await requestUtil.deleteProcurement(widget.procurementData.purchaseID);
                if (response.statusCode == 200) {
                  widget.updateData();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Purchase order deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Display an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Delete purchase order failed'),
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