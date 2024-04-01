// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import 'package:prototype/models/refund_model.dart';
import 'package:prototype/util/management_util.dart';
import 'package:prototype/widgets/info_details.dart';

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
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Refund Details', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(
              Icons.delete,
              size: 24.0,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailRow('Refund ID', item.refundID, context),
              buildDetailRow('Refund Date', item.refundDate, context),
              buildDetailRow('Order ID', item.orderID, context),
              buildDetailRow('Customer', item.customerName, context),
              buildDetailRow('Customer ID', item.customerID.toString(), context),
              buildDetailRow('Product', item.productName, context),
              buildDetailRow('Product ID', item.productID.toString(), context),
              buildDetailRow('Refunded Quantity', item.refundQuantity.toString(), context),
              buildDetailRow('Order Price', '\$${item.orderPrice.toStringAsFixed(2)}', context),
              buildDetailRow('Refunded Amount', '\$${item.refundAmount.toStringAsFixed(2)}', context),
              buildDetailRow('Reason', item.reason, context),
              buildDetailRow('Status', 'Refunded', context),
            ],
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
                    SnackBar(
                      content: const Text('Delete refund failed'),
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
