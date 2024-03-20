import 'dart:convert';

import "package:flutter/material.dart";
import 'package:prototype/app/sale_orders/add_order.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/app/sale_orders/order_info.dart';
import 'package:prototype/util/request_util.dart';


class SalesOrderScreen extends StatelessWidget {
  SalesOrderScreen({super.key});
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchSalesOrderData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
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
                      "Unable to load order data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              List<SalesOrder> orders = snapshot.data as List<SalesOrder>;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: 
                    DataTable(
                      columnSpacing: 16.0, // Adjust the spacing between columns
                      horizontalMargin: 16.0, // Adjust the horizontal margin
                      columns: const [
                        DataColumn(label: Text('Order ID'),),
                        DataColumn(label: Text('Customer'),),
                        DataColumn(label: Text('Customer ID'),),
                        DataColumn(label: Text('Product'),),
                        DataColumn(label: Text('Product ID'),),
                        DataColumn(label: Text('Order Date'),),
                        DataColumn(label: Text('Quantity'),),
                        DataColumn(label: Text('Unit Price'),),
                        DataColumn(label: Text('Total Price'),),
                        DataColumn(label: Text('Status'),),
                        DataColumn(label: Text('Order by'),),
                      ],
                      rows: orders.map((order) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(order.orderID),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.customerName),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.customerID),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.productName),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.productID),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.orderDate),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.quantity.toString()),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.unitPrice.toStringAsFixed(2).toString()),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.totalPrice.toStringAsFixed(2).toString()),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.status),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                            DataCell(
                              Text(order.employee),
                              onTap: () {
                                navigateToOrderDetail(context, order);
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              );
            }
            else {
              return Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Unable to load order data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              );
            }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddOrderScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<SalesOrder>> _fetchSalesOrderData() async {
    try {
      final order = await requestUtil.getSaleOrders();
      if (order.statusCode == 200) {
        // Assuming the JSON response is a list of objects
        List<dynamic> jsonData = jsonDecode(order.body);
        
        // Map each dynamic object to SalesOrder
        List<SalesOrder> orderData = jsonData.map((data) => SalesOrder.fromJson(data)).toList();
        return orderData;
      } else {
        throw Exception('Unable to fetch order data.');
      }
    } catch (error) {
      // print('Error in _fetchCustomerData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }
}
