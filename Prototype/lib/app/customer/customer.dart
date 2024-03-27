import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/add_customer.dart';
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/app/customer/customer_info.dart';
import 'package:prototype/util/get_controllers/customer_controller.dart';
import 'package:prototype/util/request_util.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final RequestUtil requestUtil = RequestUtil();
  final customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    customerController.updateData.value = updateData;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        key: futureBuilderKey,
        future: customerController.getCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: size.height * 0.9,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              height: size.height * 0.9,
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load customer data",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // Assuming snapshot.data is a List<CustomerData>
            List<CustomerData> customerData = snapshot.data as List<CustomerData>;
      
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 16.0,
                  horizontalMargin: 16.0,
                  columns: [
                    DataColumn(label: Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Business Name', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Contact Person', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Email', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Phone No', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Billing Address', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Shipping Address', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                  ],
                  rows: customerData.map((CustomerData customer) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(customer.customerID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                        DataCell(
                          Text(customer.businessName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                        DataCell(
                          Text(customer.contactPerson, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                        DataCell(
                          Text(customer.email, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                        DataCell(
                          Text(customer.phoneNo, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                        DataCell(
                          Text(customer.billingAddress, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                        DataCell(
                          Text(customer.shippingAddress, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            return Container(); // Return an empty container if none of the conditions match
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddCustomerScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}