import 'dart:convert';

import 'package:flutter/material.dart';
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
    return Scaffold(
      body: FutureBuilder(
        key: futureBuilderKey,
        future: _fetchCustomerData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.red[400],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.red[400],
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(top: 20.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load customer data",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Business Name')),
                    DataColumn(label: Text('Contact Person')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone No')),
                    DataColumn(label: Text('Billing Address')),
                    DataColumn(label: Text('Shipping Address')),
                  ],
                  rows: customerData.map((CustomerData customer) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(customer.customerID),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.businessName),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.contactPerson),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.email),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.phoneNo),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.billingAddress),
                          onTap: () {
                            navigateToCustomerDetail(context, customer, updateData);
                          },
                        ),
                        DataCell(
                          Text(customer.shippingAddress),
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