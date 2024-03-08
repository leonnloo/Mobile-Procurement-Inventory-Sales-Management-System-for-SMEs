import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class AddProcurementScreen extends StatefulWidget {
  const AddProcurementScreen({super.key});

  @override
  AddProcurementScreenState createState() => AddProcurementScreenState();
}

class AddProcurementScreenState extends State<AddProcurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();

  // late TextEditingController _procurementNameController;
  late TextEditingController _itemNameController;
  late TextEditingController _supplierNameController;
  late TextEditingController _orderDateController;
  late TextEditingController _deliveryDateController;
  late TextEditingController _unitPriceController;
  late TextEditingController _totalPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _statusController;
  late String type = 'Product';

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _supplierNameController = TextEditingController();
    _orderDateController = TextEditingController();
    _deliveryDateController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _quantityController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _itemNameController.dispose();
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
      appBar: CommonAppBar(currentTitle: 'Add Purchase'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Type', 
                  options: _getTypeList(), 
                  onChanged: (value){
                    setState(() {
                      type = value!;
                  });},
                  defaultSelected: true,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Item', 
                  options: _getItemList(type), 
                  onChanged: (value){
                      _itemNameController.text = value!;
                      _changeUnitPrice(type, _itemNameController.text);
                    },
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Supplier', 
                  options: _getSupplierList(), 
                  onChanged: (value){_supplierNameController.text = value!;},
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _orderDateController, labelText: 'Order Date'),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _deliveryDateController, labelText: 'Delivery Date'),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _quantityController, 
                  labelText: 'Quantity', 
                  onChanged: (value) {
                    _updateTotalPrice();
                  },
                ),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _unitPriceController, labelText: 'Unit Price'),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _totalPriceController, labelText: 'Total Price'),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Status', 
                  options: _getStatusList(), 
                  onChanged: (value){_statusController.text = value!;},
                  defaultSelected: false,
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
                      String? supplierName = validateTextField(_supplierNameController.text);
                      String? orderDate= validateTextField(_orderDateController.text);
                      String? deliveryDate = validateTextField(_deliveryDateController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? totalPrice = validateTextField(_totalPriceController.text);
                      String? quantity = validateTextField(_quantityController.text);
                      String? status = validateTextField(_statusController.text);
                      if (itemName == null
                        || supplierName == null
                        || orderDate == null
                        || deliveryDate == null
                        || unitPrice == null
                        || totalPrice == null
                        || quantity == null
                        || status == null) {
                        // Display validation error messages
                        _formKey.currentState?.validate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the required fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.newProcurement(
                          itemName, supplierName, orderDate, deliveryDate, unitPrice, totalPrice, quantity, status
                        );
                        
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Procurement added successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Procurement added failed'),
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
  
  Future<List<String>> _getSupplierList() async {
    final response = await requestUtil.getSuppliersName();
    final List<dynamic> suppliers = jsonDecode(response.body);
    final List<String> suppliersList = suppliers.cast<String>();
    return suppliersList;
  }
  
  Future<List<String>> _getTypeList() async {
    return ['Product', 'Inventory'];
  }

  Future<List<String>> _getItemList(String type) async {
    if (type == 'Product') {
      final response = await requestUtil.getProductName();
      final List<dynamic> items = jsonDecode(response.body);
      final List<String> itemsList = items.cast<String>();
      return itemsList;
    } else if (type == 'Inventory') {
      final response = await requestUtil.getInventoryName();
      final List<dynamic> items = jsonDecode(response.body);
      final List<String> itemsList = items.cast<String>();
      return itemsList;
    }
    return [];
  }
  
  void _changeUnitPrice(String type, String item) async {
    if (type == 'Product') {
      final response = await requestUtil.getProductUnitPrice(item);
      final items = jsonDecode(response.body);
      _unitPriceController.text = items.toString();
      _updateTotalPrice();
    } else if (type == 'Inventory') {
      final response = await requestUtil.getInventoryUnitPrice(item);
      final items = jsonDecode(response.body);
      _unitPriceController.text = items.toString();
      _updateTotalPrice();
    }
  }

  void _updateTotalPrice(){
    if (_unitPriceController.text != '' && _quantityController.text != '') {
      final totalPrice = double.parse(_unitPriceController.text) * double.parse(_quantityController.text);
      _totalPriceController.text = totalPrice.toString();
    }
  }
  
  Future<List<String>> _getStatusList() async {
    return ['Delivering', 'Completed'];
  }
}