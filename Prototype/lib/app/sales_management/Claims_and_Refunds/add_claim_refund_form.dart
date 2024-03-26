// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/get_refunds.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/order_drop_field.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/management_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/date_field.dart';
import 'package:intl/intl.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class AddClaimRefundForm extends StatefulWidget {
  const AddClaimRefundForm({super.key});

  @override
  AddClaimRefundFormState createState() => AddClaimRefundFormState();
}

class AddClaimRefundFormState extends State<AddClaimRefundForm> {
  final _formKey = GlobalKey<FormState>();
  final ManagementUtil managementUtil = ManagementUtil();
  late TextEditingController _orderIDController;
  late TextEditingController _orderStatusController;
  late TextEditingController _refundDateController;
  late TextEditingController _customerIDController;
  late TextEditingController _customerNameController;
  late TextEditingController _productIDController;
  late TextEditingController _productNameController;
  late TextEditingController _refundQuantityController;
  late TextEditingController _reasonController;
  late TextEditingController _orderPriceController;
  late TextEditingController _refundAmountController;
  SalesOrder? selectedOrder;
  double? unitPrice;
  int? orderQuantity;
  @override
  void initState() {
    super.initState();
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _orderIDController = TextEditingController();
    _orderStatusController = TextEditingController();
    _refundDateController = TextEditingController(text: formattedDate);
    _customerIDController = TextEditingController();
    _customerNameController = TextEditingController();
    _productIDController = TextEditingController();
    _productNameController = TextEditingController();
    _refundQuantityController = TextEditingController();
    _reasonController = TextEditingController();
    _orderPriceController = TextEditingController();
    _refundAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _orderIDController.dispose();
    _orderStatusController.dispose();
    _refundDateController.dispose();
    _customerIDController.dispose();
    _customerNameController.dispose();
    _productIDController.dispose();
    _productNameController.dispose();
    _refundQuantityController.dispose();
    _reasonController.dispose();
    _orderPriceController.dispose();
    _refundAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'New Claim or Refund'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderDropdownTextField(
                labelText: 'Order', 
                options: getOrderList(), 
                onChanged: (value) {
                  _orderIDController.text = value!.orderID;
                  _orderStatusController.text = value.orderStatus;
                  _productIDController.text = value.productID;
                  _productNameController.text = value.productName;
                  _customerIDController.text = value.customerID;
                  _customerNameController.text = value.customerName;
                  _orderPriceController.text = value.totalPrice.toStringAsFixed(2);
                  unitPrice = value.unitPrice;
                  orderQuantity = value.quantity;
                  setState(() {
                    selectedOrder = value;
                  });
                }
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<SalesOrder>(
                stream: getOrderDetailsStream(selectedOrder),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 150.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: null, // null indicates an indeterminate progress which spins
                          strokeWidth: 4.0, // Thickness of the circle line
                          backgroundColor: Colors.grey[200], // Color of the background circle
                          color: Colors.red[400], // Color of the progress indicator
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 150.0,
                      child: Center(
                        child: Text('Select an order', style: TextStyle(fontSize: 24.0),),
                      ),
                    );
                  } else {
                    // Assuming 'order' contains the details you need
                    final SalesOrder order = snapshot.data!;
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Order ID: ${order.orderID}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Order Date: ${order.orderDate}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Customer: ${order.customerName}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Product: ${order.productName}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Quantity: ${order.quantity}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Unit Price: \$${order.unitPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Total Price: \$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Status: ${order.orderStatus}', style: const TextStyle(fontSize: 16)),
                            // Add more fields as needed
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16.0),
              BuildDateField(controller: _refundDateController, labelText: 'Refund Date'),
              const SizedBox(height: 16.0),
              IntegerTextField(
                controller: _refundQuantityController, 
                labelText: 'Refund Quantity', 
                onChanged: (value) {
                  double totalP = unitPrice! * double.parse(value);
                  _refundAmountController.text = totalP.toStringAsFixed(2);
                  _refundQuantityController.text = value;
                }, 
                floatData: false
              ),
              const SizedBox(height: 16.0),
              IntegerTextField(
                controller: _refundAmountController, 
                labelText: 'Refund Amount', 
                onChanged: (value) {
                  _refundQuantityController.text = value;
                }, 
                floatData: false
              ),
              const SizedBox(height: 16.0),
              BuildTextField(controller: _reasonController, labelText: 'Reason'),
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
                    String? orderID = validateTextField(_orderIDController.text);
                    String? orderStatus = validateTextField(_orderStatusController.text);
                    String? refundDate = validateTextField(_refundDateController.text);
                    String? customerName = validateTextField(_customerNameController.text);
                    String? customerID = validateTextField(_customerIDController.text);
                    String? productName = validateTextField(_productNameController.text);
                    String? productID = validateTextField(_productIDController.text);
                    String? refundQuantity = validateTextField(_refundQuantityController.text);
                    String? reason = validateTextField(_reasonController.text);
                    String? orderPrice = validateTextField(_orderPriceController.text);
                    String? refundAmount = validateTextField(_refundAmountController.text);
                    if (orderID == null
                      || orderStatus == null
                      || refundDate == null
                      || customerName == null
                      || customerID == null
                      || productName == null
                      || productID == null
                      || refundQuantity == null
                      || reason == null
                      || orderPrice == null
                      || refundAmount == null) {
                      // Display validation error messages
                      _formKey.currentState?.validate();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all the required fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {         
                      if (int.parse(refundQuantity) > orderQuantity!) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Refund quantity cannot be over the initial order quantity.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }       
                      final response = await managementUtil.newRefund(
                        orderID,
                        orderStatus,
                        refundDate,
                        customerID,
                        customerName,
                        productID,
                        productName,
                        refundQuantity,
                        orderPrice,
                        refundAmount,
                        reason,
                      );
                      
                      if (response.statusCode == 200) {
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
                            content: Text('Refund failed: ${jsonDecode(response.body)['detail']}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('DONE')
                ), 
              )
            ],
          ),
        ),
      ),
    );
  }
  Stream<SalesOrder> getOrderDetailsStream(SalesOrder? order) {
    if (order == null){
      return const Stream.empty();
    }

    Future<SalesOrder> fetchOrderDetails(SalesOrder? order) async {
      await Future.delayed(const Duration(milliseconds: 300));
      return order!;
    }

    // Convert the future from fetchOrderDetails into a stream
    return Stream.fromFuture(fetchOrderDetails(order));
  }

}
