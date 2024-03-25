// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import 'package:prototype/models/refund_model.dart';
import 'package:prototype/util/management_util.dart';

void navigateToRefundDetail(BuildContext context, Refunds item, Function updateData) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => RefundDetailScreen(item: item, updateData: updateData),
    ),
  );
}

class RefundDetailScreen extends StatelessWidget {
  final Refunds item;
  final Function updateData;
  RefundDetailScreen({super.key, required this.item, required this.updateData});
  final ManagementUtil managementUtil = ManagementUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.red[400],
        title: const Text('Refund Details'),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(
              Icons.delete,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Refund ID', item.refundID),
              _buildDetailRow('Refund Date', item.refundDate),
              _buildDetailRow('Order ID', item.orderID),
              _buildDetailRow('Customer', item.customerName),
              _buildDetailRow('Customer ID', item.customerID.toString()),
              _buildDetailRow('Product', item.productName),
              _buildDetailRow('Product ID', item.productID.toString()),
              _buildDetailRow('Refunded Quantity', item.refundQuantity.toString()),
              _buildDetailRow('Order Price', '\$${item.orderPrice.toStringAsFixed(2)}'),
              _buildDetailRow('Refunded Amount', '\$${item.refundAmount.toStringAsFixed(2)}'),
              _buildDetailRow('Reason', item.reason),
              _buildDetailRow('Status', 'Refunded'),
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
                final response = await managementUtil.deleteRefund(item.refundID);
                if (response.statusCode == 200) {
                  Navigator.pop(context);
                  updateData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Refund deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Display an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete refund failed'),
                      backgroundColor: Colors.red,
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
