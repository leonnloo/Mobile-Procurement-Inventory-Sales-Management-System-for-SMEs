// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/procurement/get_procurement.dart';
import 'package:prototype/app/sale_orders/get_order.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/date_field.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/number_field.dart';

class EditOrder extends StatefulWidget {
  final SalesOrder orderData;
  final Function? updateData;
  const EditOrder({super.key, required this.orderData, this.updateData});

  @override
  EditOrderState createState() => EditOrderState();
}

class EditOrderState extends State<EditOrder> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerIDController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productIDController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _completionStatusController = TextEditingController();
  final TextEditingController _orderStatusController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _employeeIDController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    _customerNameController.text = widget.orderData.customerName;
    _customerIDController.text = widget.orderData.customerID;
    _productNameController.text = widget.orderData.productName;
    _productIDController.text = widget.orderData.productID;
    _orderDateController.text = widget.orderData.orderDate;
    _unitPriceController.text = widget.orderData.unitPrice.toStringAsFixed(2);
    _totalPriceController.text = widget.orderData.totalPrice.toStringAsFixed(2);
    _quantityController.text = widget.orderData.quantity.toString();
    _completionStatusController.text = widget.orderData.completionStatus;
    _orderStatusController.text = widget.orderData.orderStatus;
    _employeeNameController.text = widget.orderData.employee;
    _employeeIDController.text = widget.orderData.employeeID;
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerIDController.dispose();
    _productNameController.dispose();
    _productIDController.dispose();
    _orderDateController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    _quantityController.dispose();
    _orderStatusController.dispose();
    _employeeNameController.dispose();
    _employeeIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Edit Order', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: Icon(
              color: Theme.of(context).colorScheme.surface,
              Icons.delete,
              size: 30.0,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface, // Set the color of the back button
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
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Customer', 
                  options: getCustomerList(), 
                  onChanged: (value){
                    _customerNameController.text = value!;
                    updateCustomerID(value, _customerIDController);
                  },
                  defaultSelected: true,
                  data: _customerNameController.text,
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
                  defaultSelected: true,
                  data: _productNameController.text,
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
                  labelText: 'Order Status', 
                  options: getOrderStatusList(), 
                  onChanged: (value){_orderStatusController.text = value!;},
                  defaultSelected: true,
                  data: _orderStatusController.text,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Completion Status', 
                  options: getCompletionStatusList(), 
                  onChanged: (value){_completionStatusController.text = value!;},
                  defaultSelected: true,
                  data: _completionStatusController.text,
                ),
                const SizedBox(height: 16.0),
                DropdownTextField(
                  labelText: 'Employee', 
                  options: getUsersNameList(), 
                  onChanged: (value){
                    _employeeNameController.text = value!;
                    updateUserID(value, _employeeIDController);
                  },
                  defaultSelected: true,
                  data: _employeeNameController.text,
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
                        String? completionStatus = validateTextField(_completionStatusController.text);
                        String? orderStatus = validateTextField(_orderStatusController.text);
                        String? employee = validateTextField(_employeeNameController.text);
                        String? employeeID = validateTextField(_employeeIDController.text);
                        if (customerName == null
                          || customerID == null
                          || productName == null
                          || productID == null
                          || orderDate == null
                          || quantity == null
                          || unitPrice == null
                          || totalPrice == null
                          || completionStatus == null
                          || orderStatus == null
                          || employee == null
                          || employeeID == null) {
                          // Display validation error messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please fill in all the required fields.'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {                
                          final response = await requestUtil.updateSaleOrder(
                            widget.orderData.orderID, customerName, customerID, productName, productID, orderDate, unitPrice, totalPrice, quantity, orderStatus, completionStatus, employee, employeeID
                          );
                          
                          if (response.statusCode == 200) {
                            Function? update = orderController.updateData.value;
                            Function? updateEdit = orderController.updateEditData.value;
                            orderController.updateOrderInfo(SalesOrder(orderID: widget.orderData.orderID, orderDate: orderDate, customerID: customerID, customerName: customerName, productID: productID, productName: productName, quantity: int.parse(quantity), unitPrice: double.parse(unitPrice), totalPrice: double.parse(totalPrice), completionStatus: completionStatus, orderStatus: orderStatus, employee: employee, employeeID: employeeID));
                            orderController.clearOrders();
                            orderController.getOrders();
                            update!();
                            updateEdit!();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order updated successfully.'),
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
                final response = await requestUtil.deleteOrder(widget.orderData.orderID);
                
                if (response.statusCode == 200) {
                  Function? update = orderController.updateData.value;
                  orderController.clearOrders();
                  orderController.getOrders();
                  update!();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Display an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Delete order failed'),
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