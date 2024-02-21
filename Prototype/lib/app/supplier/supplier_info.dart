import "dart:math";

import "package:flutter/material.dart";
import 'package:prototype/models/supplierdata.dart';

void navigateToSupplierDetail(BuildContext context, SupplierData supplier) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SupplierDetailScreen(supplierData: supplier),
    ),
  );
}

class SupplierDetailScreen extends StatelessWidget {
  final SupplierData supplierData;

  const SupplierDetailScreen({super.key, required this.supplierData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Supplier ID', supplierData.supplierID.toString()),
            _buildDetailRow('Supplier Name', supplierData.supplierName),
            _buildDetailRow('Contact Person', supplierData.contactPerson),
            _buildDetailRow('Email', supplierData.email),
            _buildDetailRow('Phone number', supplierData.phoneno),
            _buildDetailRow('Address', supplierData.address),

            const SizedBox(height: 6.0), // Add some spacing
            _buildNotes(),
            
            const SizedBox(height: 6.0),
            _buildHistory(),

            const SizedBox(height: 6.0),
            _buildPastOrders()
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 30.0), // Increase the spacing between label and text
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNotes(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: 
      // Section for User's Remark
      Align(
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
              const Text(
                'Note:                                                           ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                supplierData.remark ?? 'No remark available',
                style: const TextStyle(fontSize: 16),
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

Widget _buildHistory() {
  List<String> historyEntries = generateRandomHistory();

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: historyEntries.map((history) {
        return Row(
          children: [
            const Icon(Icons.history, color: Colors.blue),
            const SizedBox(width: 8.0),
            Text(history),
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

Widget _buildPastOrders() {
  List<PastOrder> pastOrders = generatePastOrders();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Past Orders:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                Text('Order ${order.orderNumber} - ${order.orderDate} - \$${order.totalAmount.toStringAsFixed(2)}'),
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
