// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/procurement/get_procurement.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/util/get_controllers/procurement_controller.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/date_field.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';

class AddProcurementScreen extends StatefulWidget {
  const AddProcurementScreen({super.key, this.updateData});
  final Function? updateData;
  @override
  AddProcurementScreenState createState() => AddProcurementScreenState();
}

class AddProcurementScreenState extends State<AddProcurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();
  late TextEditingController _itemTypeController;
  late TextEditingController _itemIDController;
  late TextEditingController _itemNameController;
  late TextEditingController _supplierNameController;
  late TextEditingController _orderDateController;
  late TextEditingController _deliveryDateController;
  late TextEditingController _unitPriceController;
  late TextEditingController _totalPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _statusController;
  late String type = 'Product';
  final procurementController = Get.put(PurchaseController());
  final productController = Get.put(ProductController());
  final inventoryController = Get.put(InventoryController());

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _itemIDController = TextEditingController();
    _itemTypeController = TextEditingController();
    _supplierNameController = TextEditingController();
    _orderDateController = TextEditingController();
    _deliveryDateController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _quantityController = TextEditingController();
    _statusController = TextEditingController();
    _itemTypeController.text = type;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemIDController.dispose();
    _itemTypeController.dispose();
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
      appBar: const CommonAppBar(currentTitle: 'Add Purchase'),
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
                  options: getProcurementTypeList(), 
                  onChanged: (value){
                    _itemTypeController.text = value!;
                    setState(() {
                      type = value;
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
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Supplier', 
                  options: getSupplierList(), 
                  onChanged: (value){_supplierNameController.text = value!;},
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                BuildDateField(controller: _orderDateController, labelText: 'Order Date'),
                const SizedBox(height: 16.0),
                BuildDateField(controller: _deliveryDateController, labelText: 'Delivery Date'),
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
                IntegerTextField(
                  controller: _totalPriceController, 
                  labelText: 'Total Price', 
                  onChanged: (value) {},
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Status', 
                  options: getProcurementStatusList(), 
                  onChanged: (value){_statusController.text = value!;},
                  defaultSelected: false,
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
                      String? itemID = validateTextField(_itemIDController.text);
                      String? itemType = validateTextField(_itemTypeController.text);
                      String? supplierName = validateTextField(_supplierNameController.text);
                      String? orderDate= validateTextField(_orderDateController.text);
                      String? deliveryDate = validateTextField(_deliveryDateController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? totalPrice = validateTextField(_totalPriceController.text);
                      String? quantity = validateTextField(_quantityController.text);
                      String? status = validateTextField(_statusController.text);
                      if (itemName == null
                        || itemID == null
                        || itemType == null
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
                          SnackBar(
                            content: const Text('Please fill in all the required fields.'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.newProcurement(
                          itemName, itemType, itemID, supplierName, orderDate, deliveryDate, unitPrice, totalPrice, quantity, status
                        );
                        
                        if (response.statusCode == 200) {
                          Function? updatePurchase = procurementController.updateData.value;
                          procurementController.clearPurchases();
                          procurementController.getPurchases();
                          if (updatePurchase != null) {
                            updatePurchase();
                          }
                          if (status == 'Completed') {
                            Function? updateInventory = inventoryController.updateData.value;
                            inventoryController.clearInventories();
                            inventoryController.getInventories();
                            if (updateInventory!= null){
                              updateInventory();
                            }
                            Function? updateProduct = productController.updateData.value;
                            productController.clearProducts();
                            productController.getProducts();
                            if (updateProduct!= null){
                              updateProduct();
                            }
                          }
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
                            SnackBar(
                              content: const Text('Procurement added failed'),
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