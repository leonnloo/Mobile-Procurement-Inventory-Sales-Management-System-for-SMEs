import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/app/procurement/procurement_info.dart';
import 'package:prototype/app/procurement/procurement_filter_system.dart';
import 'package:prototype/util/request_util.dart';

class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});

  @override
  State<ProcurementScreen> createState() => _ProcurementScreenState();
}

class _ProcurementScreenState extends State<ProcurementScreen> {
  @override
  Widget build(BuildContext context) {
    String dummy = '';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: ListView(
          children:  <Widget>[
            //filter system
              SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const FilterSystem());
                    },
                    child: const TextField(
                      decoration: InputDecoration(
                      enabled: false,
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    ),
                  ),
                ),
              ),
            ),
          
            // const Card(
            //   elevation: 4.0,
            //   margin: EdgeInsets.all(16.0),
            //   child: Padding(
            //     padding: EdgeInsets.all(16.0),
            //     child: MonthlyPurchaseStatic(),
            //   ),
            // ),
            /*const Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: MonthlyPurchaseChart(),
              ),
            ),*/
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.red[400],
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              labelPadding: const EdgeInsets.all(10),
              tabs: const [
                Tab(text: 'Delivered'),
                Tab(text: 'Ongoing'),
              ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                children: [
                  ProcurementTab(category: 'Past', dummy: dummy,),
                  ProcurementTab(category: 'Present', dummy: dummy,),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to a screen for adding new customer info
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddProcurementScreen(updateData: updateData,),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  void updateData(){
    setState(() {
      
    });
  }
}

class ProcurementTab extends StatefulWidget {
  final String category;
  final String dummy;
  const ProcurementTab({super.key, required this.category, required this.dummy});

  @override
  State<ProcurementTab> createState() => _ProcurementTabState();
}

class _ProcurementTabState extends State<ProcurementTab> {
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: futureBuilderKey,
      future: _fetchProcurementData(widget.category, widget.dummy),
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
            List<PurchasingOrder> orders =
                snapshot.data as List<PurchasingOrder>;
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
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.itemName),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.supplierName),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.orderDate),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.deliveryDate),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.quantity.toString()),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.unitPrice.toStringAsFixed(2).toString()),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.totalPrice.toStringAsFixed(2).toString()),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.status),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            );
          } else {
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
        });
  }

  Future<List<PurchasingOrder>> _fetchProcurementData(String category, String dummy) async {
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
        List<PurchasingOrder> procurementData =
            jsonData.map((data) => PurchasingOrder.fromJson(data)).toList();
        return procurementData;
      } else {
        throw Exception('Unable to fetch procurement data.');
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

void navigateToOrderDetail(BuildContext context, PurchasingOrder order, Function updateData) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order, updateData: updateData)),
  );
}
