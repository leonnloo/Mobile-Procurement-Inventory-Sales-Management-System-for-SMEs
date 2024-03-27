// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/procurement/get_procurement.dart';
import 'package:prototype/app/sale_orders/get_order.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/date_field.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';

class AddOrderScreen extends StatefulWidget {
  final Function? updateData;
  const AddOrderScreen({super.key, this.updateData});
  @override
  AddOrderScreenState createState() => AddOrderScreenState();
}

class AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();
  late TextEditingController _customerNameController;
  late TextEditingController _customerIDController;
  late TextEditingController _orderDateController;
  late TextEditingController _productNameController;
  late TextEditingController _productIDController;
  late TextEditingController _unitPriceController;
  late TextEditingController _totalPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _statusController;
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController();
    _customerIDController = TextEditingController();
    _orderDateController = TextEditingController();
    _productNameController = TextEditingController();
    _productIDController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _quantityController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerIDController.dispose();
    _orderDateController.dispose();
    _productNameController.dispose();
    _productIDController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    _quantityController.dispose();
    _statusController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Add Order'),
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
                  labelText: 'Customer', 
                  options: getCustomerList(), 
                  onChanged: (value){
                    _customerNameController.text = value!;
                    updateCustomerID(value, _customerIDController);
                  },
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Product', 
                  options: getProductList(), 
                  onChanged: (value){
                    _productNameController.text = value!;
                    updateProductID(value, _productIDController);
                    updateUnitPrice(value, _unitPriceController, _quantityController, _totalPriceController);
                  },
                  defaultSelected: false,
                ),
                const SizedBox(height: 16.0),
                BuildDateField(controller: _orderDateController, labelText: 'Order Date'),
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
                  options: getOrderStatusList(), 
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
                      String? customerName = validateTextField(_customerNameController.text);
                      String? customerID = validateTextField(_customerIDController.text);
                      String? productName = validateTextField(_productNameController.text);
                      String? productID = validateTextField(_productIDController.text);
                      String? orderDate= validateTextField(_orderDateController.text);
                      String? quantity = validateTextField(_quantityController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? totalPrice = validateTextField(_totalPriceController.text);
                      String? status = validateTextField(_statusController.text);
                      if (customerName == null
                        || customerID == null
                        || productName == null
                        || productID == null
                        || orderDate == null
                        || quantity == null
                        || unitPrice == null
                        || totalPrice == null
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
                        final response = await requestUtil.newOrder(
                          customerName, customerID, productName, productID, orderDate, unitPrice, totalPrice, quantity, status
                        );
                        
                        if (response.statusCode == 200) {
                          Function? update = orderController.updateData.value;
                          orderController.clearOrders();
                          orderController.getOrders();
                          if (update != null) {
                            update();
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order added successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order added failed: ${jsonDecode(response.body)['detail']}'),
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