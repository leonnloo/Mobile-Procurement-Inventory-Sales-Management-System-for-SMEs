// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/app/procurement/procurement_info.dart';
import 'package:prototype/app/procurement/procurement_filter_system.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/util/get_controllers/procurement_controller.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';

final procurementController = Get.put(PurchaseController());
final inventoryController = Get.put(InventoryController());
final productController = Get.put(ProductController());
class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});

  @override
  State<ProcurementScreen> createState() => _ProcurementScreenState();
}

class _ProcurementScreenState extends State<ProcurementScreen> {
  String dummy = '';
  Map<String, List<PurchasingOrder>> groupedData = {};
  String? _selectedFilter = 'ID';

  Key futureBuilderKey = UniqueKey();
  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    procurementController.updateData.value = updateData;
    procurementController.updateFilter.value = updateFilter;
    groupedData['Completed'] = [];
    groupedData['Delivering'] = [];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
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
                Tab(text: 'Completed',),
                Tab(text: 'Ongoing'),
              ],
            ),
            FutureBuilder(
              key: futureBuilderKey,
              future: procurementController.getPurchases(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 150.0,
                    child: Center(
                      child: Text('Unable to load', style: TextStyle(fontSize: 14.0),),
                    ),
                  );
                } else {
                  List<PurchasingOrder> purchaseList = snapshot.data!;
                  for (var data in purchaseList) {
                    groupedData[data.status]?.add(data);
                  }
                  return Expanded(
                    child: TabBarView(
                      children: [
                        buildPurchaseSection(context, groupedData['Completed']!),
                        buildPurchaseSection(context, groupedData['Delivering']!),
                      ]
                    ),
                  );
                }
              }
            ),  
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: const CircleBorder(),
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
      ),
    );
  }
  
  Widget buildPurchaseSection(BuildContext context, List<PurchasingOrder> purchaseList) {
    bool check = false; // Initialize check variabPurchase
    purchaseList = _fetchAndFilterPurchase(purchaseList);
    Function update = procurementController.updateFilter.value!;

    for (var order in purchaseList) {
      if (order.status == 'Delivering') { 
        check = true;
        break;
      }
    }
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16.0,
          horizontalMargin: 16.0,
            columns: [
              if (check) DataColumn(label: Text('', style: TextStyle(color: Theme.of(context).colorScheme.onSurface))),
              DataColumn(
                label: Row(
                  children: [
                    Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('ID');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Item', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Item');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Supplier', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Supplier');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Order Date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Order Date');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Delivery Date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Delivery Date');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Quantity');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Unit Price');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Total Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Total Price');
                },
              ),
              DataColumn(
                label: Row(
                  children: [
                    Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    Icon(
                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) {
                  ascending = trackAscending;
                  trackAscending = !ascending;
                  update('Status');
                },
              ),
            ],
          rows: purchaseList.map((PurchasingOrder order) {
            return DataRow(
              cells: [
                if (check) DataCell(
                  Icon(Icons.check, color: Theme.of(context).colorScheme.onSurface),
                  onTap: () async {
                    final response = await requestUtil.updateProcurementStatus(
                      order.purchaseID, order.itemName, order.itemType, order.itemID, order.supplierName, order.orderDate, order.deliveryDate, order.unitPrice, order.totalPrice, order.quantity, order.status
                    );
                    
                    if (response.statusCode == 200) {
                      Function? update = procurementController.updateData.value;
                      procurementController.clearPurchases();
                      procurementController.getPurchases();
                      update!();
                      Function? updateInventory = inventoryController.updateData.value;
                      inventoryController.clearInventories();
                      inventoryController.getInventories();
                      if (updateInventory!= null){
                        updateInventory();
                      }
                      Function? updateProduct = productController.updateData.value;
                      productController.clearProducts();
                      productController.getProducts();
                      if (updateProduct!= null){
                        updateProduct();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Purchase order completed.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      setState(() {
                        
                      });
                    } else {
                      // Display an error message to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Purchase complete failed: ${jsonDecode(response.body)['detail']}'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  },
                ),
                DataCell(
                  Text(order.purchaseID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.itemName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.supplierName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.orderDate, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.deliveryDate, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.quantity.toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.unitPrice.toStringAsFixed(2).toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.totalPrice.toStringAsFixed(2).toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.status, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
              ],
            );
          }).toList(),
        )
      ),
    );
  }
  bool trackAscending = false;

  List<PurchasingOrder> _fetchAndFilterPurchase(List<PurchasingOrder> purchase) {
    if (_selectedFilter == null) {
      return [];
    } else {
      switch (_selectedFilter) {
        case 'ID':
          return purchase
            ..sort((a, b) {
              int idA = int.parse(a.purchaseID.substring(2)); // Extract numeric part from purchaseID
              int idB = int.parse(b.purchaseID.substring(2));
              return trackAscending ? idA.compareTo(idB) : idB.compareTo(idA);
            });
        case 'Item':
          return purchase
            ..sort((a, b) => trackAscending ? a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()) : b.itemName.toLowerCase().compareTo(a.itemName.toLowerCase()));
        case 'Supplier':
          return purchase
            ..sort((a, b) => trackAscending ? a.supplierName.toLowerCase().compareTo(b.supplierName.toLowerCase()) : b.supplierName.toLowerCase().compareTo(a.supplierName.toLowerCase()));
        case 'Order Date':
          return purchase..sort((a, b) {
            DateTime dateA = DateTime.parse(a.orderDate);
            DateTime dateB = DateTime.parse(b.orderDate);
            return trackAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
          });
        case 'Delivery Date':
          return purchase..sort((a, b) {
            DateTime dateA = DateTime.parse(a.deliveryDate);
            DateTime dateB = DateTime.parse(b.deliveryDate);
            return trackAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
          });
        case 'Quantity':
          return purchase
            ..sort((a, b) => trackAscending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));
        case 'Unit Price':
          return purchase
            ..sort((a, b) => trackAscending ? a.unitPrice.compareTo(b.unitPrice) : b.unitPrice.compareTo(a.unitPrice));
        case 'Total Price':
          return purchase
            ..sort((a, b) => trackAscending ? a.totalPrice.compareTo(b.totalPrice) : b.totalPrice.compareTo(a.totalPrice));
        case 'Status':
          return purchase
            ..sort((a, b) => trackAscending ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
        default:
          return purchase;
      }

    }
  }

  void updateFilter(String filter) async {
    if (mounted) {
      setState(() {
        _selectedFilter = filter;
      });
    }
  }
}

void navigateToOrderDetail(BuildContext context, PurchasingOrder purchase) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderDetailScreen(purchase: purchase)),
  );
}
