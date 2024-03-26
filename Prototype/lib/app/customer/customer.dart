import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/add_customer.dart';
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/app/customer/customer_info.dart';
import 'package:prototype/util/request_util.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        key: futureBuilderKey,
        future: _fetchCustomerData(),
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
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.businessName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.contactPerson, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.email, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.phoneNo, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.billingAddress, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.shippingAddress, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
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

  Future<List<CustomerData>> _fetchCustomerData() async {
    try {
      final customer = await requestUtil.getCustomers();
      if (customer.statusCode == 200) {
        // Assuming the JSON response is a list of objects
        List<dynamic> jsonData = jsonDecode(customer.body);
        
        // Map each dynamic object to CustomerData
        List<CustomerData> customerData = jsonData.map((data) => CustomerData.fromJson(data)).toList();
        return customerData;
      } else {
        throw Exception('Unable to fetch customer data.');
      }
    } catch (error) {
      // print('Error in _fetchCustomerData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}