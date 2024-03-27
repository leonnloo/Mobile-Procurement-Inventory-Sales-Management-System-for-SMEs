import 'dart:ffi';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToOrderDetail(BuildContext context, SalesOrder order) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => OrderDetailScreen(order: order),
    ),
  );
}

// ignore: must_be_immutable
class OrderDetailScreen extends StatefulWidget {
  SalesOrder order;
  OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final orderController = Get.put(OrderController());
  void updateData(){
    setState(() {
      widget.order = orderController.currentOrderInfo.value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    orderController.updateEditData.value = updateData;
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Order Details', currentData: widget.order, editType: EditType.salesOrder),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Order ID', widget.order.orderID.toString()),
              _buildDetailRow('Customer', widget.order.customerName),
              _buildDetailRow('Customer ID', widget.order.customerID.toString()),
              _buildDetailRow('Product', widget.order.productName),
              _buildDetailRow('Product ID', widget.order.productID.toString()),
              _buildDetailRow('Order Date', widget.order.orderDate),
              _buildDetailRow('Quantity', widget.order.quantity.toString()),
              _buildDetailRow('Unit Price', '\$${widget.order.unitPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Total Price', '\$${widget.order.totalPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Status', widget.order.orderStatus),
              _buildDetailRow('Employee', widget.order.employee),
              _buildDetailRow('Employee ID', widget.order.employeeID),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}
