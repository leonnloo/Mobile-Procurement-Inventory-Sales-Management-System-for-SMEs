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
                    child: TextField(
                      decoration: InputDecoration(
                      enabled: false,
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface,),
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      labelText: 'Search',
                      border: const OutlineInputBorder(
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
              labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimaryContainer,
              indicatorColor: Theme.of(context).colorScheme.primary,
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
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
            return SizedBox(
              height: double.infinity,
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
              height: double.infinity,
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load procurement data",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
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
                    columns: [
                      DataColumn(label: Text('Order ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Item', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Supplier', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Order Date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Delivery Date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Total Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                      DataColumn(label: Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),),
                    ],
                    rows: orders.map((order) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(order.purchaseID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.itemName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.supplierName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.orderDate, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.deliveryDate, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.quantity.toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.unitPrice.toStringAsFixed(2).toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.totalPrice.toStringAsFixed(2).toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                            onTap: () {
                              navigateToOrderDetail(context, order, updateData);
                            },
                          ),
                          DataCell(
                            Text(order.status, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load procurement data",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
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
