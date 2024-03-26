// ignore_for_file: use_build_context_synchronously

import "dart:math";

import "package:flutter/material.dart";
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/supplier_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToSupplierDetail(BuildContext context, SupplierData supplier, Function updateData) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SupplierDetailScreen(supplierData: supplier, updateData: updateData,),
    ),
  );
}

class SupplierDetailScreen extends StatelessWidget {
  final SupplierData supplierData;
  final Function updateData;
  const SupplierDetailScreen({super.key, required this.supplierData, required this.updateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Supplier Details', currentData: supplierData, editType: EditType.supplier, updateData: updateData),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Supplier ID', supplierData.supplierID, context),
            _buildDetailRow('Supplier Name', supplierData.businessName, context),
            _buildDetailRow('Contact Person', supplierData.contactPerson, context),
            _buildDetailRow('Email', supplierData.email, context),
            _buildDetailRow('Phone number', supplierData.phoneNo, context),
            _buildDetailRow('Address', supplierData.address, context),
                
            const SizedBox(height: 6.0), // Add some spacing
            _buildNotes(context),
            
            const SizedBox(height: 6.0),
            _buildHistory(context),
                
            const SizedBox(height: 6.0),
            _buildPastOrders(context)
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 30.0), // Increase the spacing between label and text
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNotes(BuildContext context){
    final TextEditingController notesController = TextEditingController();
    notesController.text = supplierData.notes!;

    final RequestUtil requestUtil = RequestUtil();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // You can set the color of the border
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text(
                          'Note:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      SizedBox(
                        child: TextButton(
                          onPressed: () async {
                            final response = await requestUtil.updateNote(supplierData.supplierID, notesController.text);
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Note saved!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              return;
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Note save failed!'),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          }, 
                          child: const Text('Save'),
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: notesController,
                  maxLines: null, // Allow text to wrap to multiple lines
                  minLines: 1,    // Set the minimum number of lines to show
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}


List<String> generateRandomHistory() {
  final Random random = Random();
  final List<String> historyList = [
    'Placed an order on ${DateTime.now().subtract(const Duration(days: 5)).toString().split(' ')[0]}',
    'Received a delivery on ${DateTime.now().subtract(const Duration(days: 3)).toString().split(' ')[0]}',
    'Returned a product on ${DateTime.now().subtract(const Duration(days: 2)).toString().split(' ')[0]}',
    // Add more history entries as needed
  ];

  return List.generate(3, (index) {
    return historyList[random.nextInt(historyList.length)];
  });
}

Widget _buildHistory(BuildContext context) {
  List<String> historyEntries = generateRandomHistory();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: historyEntries.map((history) {
        return Row(
          children: [
            Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8.0),
            Text(history, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
          ],
        );
      }).toList(),
    ),
  );
}
List<PastOrder> generatePastOrders() {
  // final Random random = Random();

  return List.generate(5, (index) {
    return PastOrder(
      orderNumber: 'Order${1000 + index}',
      orderDate: DateTime.now().subtract(Duration(days: index + 10)).toString().split(' ')[0],
      totalAmount: 100.0 + index * 20,
    );
  });
}

Widget _buildPastOrders(BuildContext context) {
  List<PastOrder> pastOrders = generatePastOrders();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Past Orders:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
      ),
      const SizedBox(height: 8.0),
      Column(
        children: pastOrders.map((order) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.green),
                const SizedBox(width: 8.0),
                Text('Order ${order.orderNumber} - ${order.orderDate} - \$${order.totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}


class PastOrder {
  final String orderNumber;
  final String orderDate;
  final double totalAmount;

  PastOrder({
    required this.orderNumber,
    required this.orderDate,
    required this.totalAmount,
  });

}
