// ignore_for_file: use_build_context_synchronously

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/util/get_controllers/customer_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'dart:math';
import 'package:prototype/widgets/appbar/info_appbar.dart';
import 'package:prototype/widgets/info_details.dart';

void navigateToCustomerDetail(BuildContext context, CustomerData customer) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CustomerDetailScreen(customer: customer),
    ),
  );
}

// ignore: must_be_immutable
class CustomerDetailScreen extends StatefulWidget {
  CustomerData customer;
  CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final customerController = Get.put(CustomerController());

  void updateEditData(){
    if (mounted) {
      setState(() {
        widget.customer = customerController.currentCustomerInfo.value!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    customerController.updateEditData.value = updateEditData;
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Customer Details', currentData: widget.customer, editType: EditType.customer),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailRow('Customer ID', widget.customer.customerID, context),
            buildDetailRow('Business Name', widget.customer.businessName, context),
            buildDetailRow('Contact Person', widget.customer.contactPerson, context),
            buildDetailRow('Email', widget.customer.email, context),
            buildDetailRow('Phone Number', widget.customer.phoneNo, context),
            buildDetailRow('Billing Address', widget.customer.billingAddress, context),
            buildDetailRow('Shipping Address', widget.customer.shippingAddress, context),

            const SizedBox(height: 6.0), // Add some spacing
            _buildNotes(context),
            
            // const SizedBox(height: 6.0),
            // _buildHistory(context),

            // const SizedBox(height: 6.0),
            // _buildPastOrders(context)
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context){
    final TextEditingController notesController = TextEditingController();
    notesController.text = widget.customer.notes!;

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
                            final response = await requestUtil.updateNote(widget.customer.customerID, notesController.text);
                            if (response.statusCode == 200) {
                              customerController.clearCustomers();
                              customerController.getCustomers();
                              Function? update = customerController.updateData.value;
                              if (update!= null) {
                                update();
                              }
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

// Widget _buildHistory(BuildContext context) {
  // List<SalesOrder>? pastOrders = widget.customer.pastOrder;

  // return Padding(
  //   padding: const EdgeInsets.all(16.0),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: pastOrders?.map((order) {
  //       return Row(
  //         children: [
  //           Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
  //           const SizedBox(width: 8.0),
  //           Text('Placed an order on ${order.orderDate} - ${order.orderStatus}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //         ],
  //       );
  //       // ! do empty history after completing adding orders
  //     }).toList() ?? [],
  //   ),
  // );
// }

List<PastOrder> generatePastOrders() {

    return List.generate(5, (index) {
      return PastOrder(
        orderNumber: 'Order${1000 + index}',
        orderDate: DateTime.now().subtract(Duration(days: index + 10)).toString().split(' ')[0],
        totalAmount: 100.0 + index * 20,
      );
    });
  }

  // ignore: unused_element
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
