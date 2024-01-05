import 'package:flutter/material.dart';
import 'package:prototype/app/customer/addcustomer.dart';
import 'package:prototype/app/customer/customerdata.dart';
import 'package:prototype/app/customer/customerinfo.dart';
import 'package:prototype/widgets/bottomnavigator.dart';

class CustomerManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 16.0,
            horizontalMargin: 16.0,
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
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
                    Text(customer.customerID.toString()),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                  DataCell(
                    Text(customer.customerName ?? 'N/A'),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                  DataCell(
                    Text(customer.contactPerson ?? 'N/A'),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                  DataCell(
                    Text(customer.email ?? 'N/A'),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                  DataCell(
                    Text(customer.phoneno),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                  DataCell(
                    Text(customer.billingAddress),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                  DataCell(
                    Text(customer.shippingAddress),
                    onTap: () {
                      navigateToCustomerDetail(context, customer);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddCustomerScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

