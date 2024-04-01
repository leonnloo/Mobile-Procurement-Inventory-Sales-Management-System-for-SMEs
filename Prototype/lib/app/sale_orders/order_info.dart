import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';
import 'package:prototype/widgets/info_details.dart';

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
    if (mounted) {
      setState(() {
        widget.order = orderController.currentOrderInfo.value!;
      });
    }
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
              buildDetailRow('Order ID', widget.order.orderID.toString(), context),
              buildDetailRow('Customer', widget.order.customerName, context),
              buildDetailRow('Customer ID', widget.order.customerID.toString(), context),
              buildDetailRow('Product', widget.order.productName, context),
              buildDetailRow('Product ID', widget.order.productID.toString(), context),
              buildDetailRow('Order Date', widget.order.orderDate, context),
              buildDetailRow('Quantity', widget.order.quantity.toString(), context),
              buildDetailRow('Unit Price', '\$${widget.order.unitPrice.toStringAsFixed(2)}', context),
              buildDetailRow('Total Price', '\$${widget.order.totalPrice.toStringAsFixed(2)}', context),
              buildDetailRow('Status', widget.order.orderStatus, context),
              buildDetailRow('Employee', widget.order.employee, context),
              buildDetailRow('Employee ID', widget.order.employeeID, context),
            ],
          ),
        ),
      ),
    );
  }
}
