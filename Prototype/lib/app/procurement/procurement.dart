import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/app/procurement/procurement_info.dart';
import 'package:prototype/util/request_util.dart';

class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});

  @override
  ProcurementScreenState createState() => ProcurementScreenState();
}

class ProcurementScreenState extends State<ProcurementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Past'),
                Tab(text: 'Present'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProcurementTab(category: 'Past'),
                  ProcurementTab(category: 'Present'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddProcurementScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProcurementTab extends StatelessWidget {
  final String category;

  ProcurementTab({super.key, required this.category});
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchProcurementData(category),
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
                    "Unable to load procurement data",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            List<PurchasingOrder> orders = snapshot.data as List<PurchasingOrder>;
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
                      DataColumn(label: Text('Item'),),
                      DataColumn(label: Text('Supplier'),),
                      DataColumn(label: Text('Order Date'),),
                      DataColumn(label: Text('Delivery Date'),),
                      DataColumn(label: Text('Quantity'),),
                      DataColumn(label: Text('Unit Price'),),
                      DataColumn(label: Text('Total Price'),),
                      DataColumn(label: Text('Status'),),
                    ],
                    rows: orders.map((order) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(order.purchaseID),
                            onTap: () {
                              navigateToOrderDetail(context, order);
                            },
                          ),
                          DataCell(
                            Text(order.itemName),
                            onTap: () {
                              navigateToOrderDetail(context, order);
                            },
                          ),
                          DataCell(
                            Text(order.supplierName),
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
                            Text(order.deliveryDate),
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
                    "Unable to load procurement data",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          }
      }
    );
  }
  Future<List<PurchasingOrder>> _fetchProcurementData(String category) async {
    try {
      String newCategory;
      if (category == 'Past') {
        newCategory = 'Completed';
      } else {
        newCategory = 'Delivering';
      }
      
      final procurement = await requestUtil.getProcurementCategory(newCategory);
      if (procurement.statusCode == 200) {
        // Assuming the JSON response is a list of objects
        List<dynamic> jsonData = jsonDecode(procurement.body);
        
        // Map each dynamic object to PurchasingOrder
        List<PurchasingOrder> procurementData = jsonData.map((data) => PurchasingOrder.fromJson(data)).toList();
        return procurementData;
      } else {
        throw Exception('Unable to fetch procurement data.');
      }
    } catch (error) {
      // print('Error in _fetchCustomerData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }
}



  
void navigateToOrderDetail(BuildContext context, PurchasingOrder order) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)),
  );
}





