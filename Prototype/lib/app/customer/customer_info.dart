import "package:flutter/material.dart";
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/request_util.dart';
import 'dart:math';
import 'package:prototype/widgets/appbar/info_appbar.dart';

void navigateToCustomerDetail(BuildContext context, CustomerData customer) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CustomerDetailScreen(customer: customer),
    ),
  );
}

class CustomerDetailScreen extends StatelessWidget {
  final CustomerData customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Customer Details', currentData: customer, editType: EditType.customer,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Customer ID', customer.customerID),
            _buildDetailRow('Business Name', customer.businessName),
            _buildDetailRow('Contact Person', customer.contactPerson),
            _buildDetailRow('Email', customer.email),
            _buildDetailRow('Phone Number', customer.phoneNo),
            _buildDetailRow('Billing Address', customer.billingAddress),
            _buildDetailRow('Shipping Address', customer.shippingAddress),

            const SizedBox(height: 6.0), // Add some spacing
            _buildNotes(context),
            
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


  Widget _buildNotes(BuildContext context){
    final TextEditingController notesController = TextEditingController();
    notesController.text = customer.notes!;

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
                      const SizedBox(
                        child: Text(
                          'Note:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        child: TextButton(
                          onPressed: () async {
                            final response = await requestUtil.updateNote(customer.customerID, notesController.text);
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
                                const SnackBar(
                                  content: Text('Note save failed!'),
                                  backgroundColor: Colors.red,
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
  List<SalesOrder>? pastOrders = customer.pastOrder;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pastOrders?.map((order) {
        return Row(
          children: [
            const Icon(Icons.history, color: Colors.blue),
            const SizedBox(width: 8.0),
            Text('Placed an order on ${order.orderDate} - ${order.orderStatus}'),
          ],
        );
        // ! do empty history after completing adding orders
      }).toList() ?? [],
    ),
  );
}


List<PastOrder> generatePastOrders() {

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
