import "package:flutter/material.dart";
import "package:prototype/app/customer/customerdata.dart";
import 'dart:math';

void navigateToCustomerDetail(BuildContext context, CustomerData customer) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CustomerDetailScreen(customer: customer),
    ),
  );
}

class CustomerDetailScreen extends StatelessWidget {
  final CustomerData customer;

  CustomerDetailScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Customer ID', customer.customerID.toString()),
            _buildDetailRow('Customer Name', customer.customerName ?? 'N/A'),
            _buildDetailRow('Contact Person', customer.contactPerson ?? 'N/A'),
            _buildDetailRow('Email', customer.email ?? 'N/A'),
            _buildDetailRow('Phone number', customer.phoneno ?? 'N/A'),
            _buildDetailRow('Billing address', customer.billingAddress ?? 'N/A'),
            _buildDetailRow('Shipping Address', customer.shippingAddress ?? 'N/A'),

            SizedBox(height: 6.0), // Add some spacing
            _buildNotes(),
            
            SizedBox(height: 6.0),
            _buildHistory(),

            SizedBox(height: 6.0),
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
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 30.0), // Increase the spacing between label and text
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildNotes(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: 
      // Section for User's Remark
      Align(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // You can set the color of the border
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Note:                                                           ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                customer.remark ?? 'No remark available',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
  

List<String> generateRandomHistory() {
  final Random random = Random();
  final List<String> historyList = [
    'Placed an order on ${DateTime.now().subtract(Duration(days: 5)).toString().split(' ')[0]}',
    'Received a delivery on ${DateTime.now().subtract(Duration(days: 3)).toString().split(' ')[0]}',
    'Returned a product on ${DateTime.now().subtract(Duration(days: 2)).toString().split(' ')[0]}',
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
            Icon(Icons.history, color: Colors.blue),
            SizedBox(width: 8.0),
            Text(history),
          ],
        );
      }).toList(),
    ),
  );
}
List<PastOrder> generatePastOrders() {
    final Random random = Random();

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
        Text(
          'Past Orders:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Column(
          children: pastOrders.map((order) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.green),
                  SizedBox(width: 8.0),
                  Text('Order ${order.orderNumber} - ${order.orderDate} - \$${order.totalAmount.toStringAsFixed(2)}'),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
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
