import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:prototype/app/inventory/inventory_filter_system.dart';
import 'package:prototype/app/inventory/speed_dial_inventory.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/app/inventory/inventory_info.dart';
import 'package:prototype/util/request_util.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final RequestUtil requestUtil = RequestUtil();

  Map<String, List<InventoryItem>> groupedData = {};
  @override
  Widget build(BuildContext context) {
  groupedData['In Stock'] = [];
  groupedData['Low Stock'] = [];
  groupedData['Out of Stock'] = [];
    return DefaultTabController(
      length: groupedData.keys.length,
      initialIndex: 0,
      child: Scaffold(
        body: Column(
          children: [
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
        
            // Card(
            //   elevation: 4.0,
            //   margin: const EdgeInsets.all(16.0),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: BarChartSample4(),
            //   ),
            // ),
            TabBar(
              labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimaryContainer,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              labelPadding: const EdgeInsets.all(10),
              tabs: groupedData.keys.map((status) => Tab(text: status)).toList(),
            ),
            FutureBuilder(
              key: futureBuilderKey,
              future: _fetchInventoryData(),
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
                  List<InventoryItem> inventoryItems = snapshot.data!;
                  for (var data in inventoryItems) {
                    groupedData[data.status]?.add(data);
                  }
                  return Expanded(
                    child: TabBarView(
                      children: [
                        buildInventorySection(context, groupedData['In Stock']!),
                        buildInventorySection(context, groupedData['Low Stock']!),
                        buildInventorySection(context, groupedData['Out of Stock']!),
                      ]
                    ),
                  );
                }
              }
            ),
          ],
        ),
        floatingActionButton: inventorySpeedDial(context, updateData),
      ),
    );
  }

  Widget buildInventorySection(BuildContext context, List<InventoryItem> inventoryItems) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16.0,
          horizontalMargin: 16.0,
          columns: [
            DataColumn(label: Text('Item ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
            DataColumn(label: Text('Item', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
            DataColumn(label: Text('Category', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
            DataColumn(label: Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
            DataColumn(label: Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
            DataColumn(label: Text('Total Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
            DataColumn(label: Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
          ],
          rows: inventoryItems.map((InventoryItem item) {
            return DataRow(
              cells: [
                DataCell(
                  Text(item.itemID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
                DataCell(
                  Text(item.itemName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
                DataCell(
                  Text(item.category, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
                DataCell(
                  Text(
                    item.quantity.toString(),
                    style: TextStyle(
                    color: _getQuantityColor(
                      item.quantity,
                      item.criticalLvl,
                      ),
                    ),
                  ),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
                DataCell(
                  Text('\$${item.unitPrice.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
                DataCell(
                  Text('\$${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
                DataCell(
                  Text(item.status, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item, updateData);
                  },
                ),
              ],
            );
          }).toList(),
        )
      ),
    );
  }

  Future<List<InventoryItem>> _fetchInventoryData() async {
    try {
      final item = await requestUtil.getInventories();
      if (item.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(item.body);
        List<InventoryItem> itemData = jsonData.map((data) => InventoryItem.fromJson(data)).toList();
        return itemData;
      } else {
        throw Exception('Unable to fetch item data.');
      }
    } catch (error) {
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Key futureBuilderKey = UniqueKey();
  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
  Color _getQuantityColor(int quantity, int safetyQuantity) {
    return quantity < safetyQuantity ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface;
  }
}



class ItemSearch extends SearchDelegate<InventoryItem> {
  final List<InventoryItem> items;

  ItemSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults(query);
  }

  Widget buildSearchResults(String query) {
    final List<InventoryItem> searchResults = items
        .where(
            (item) => item.itemName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return const SingleChildScrollView(
      child: Column(
        children: [
          // Display search results using the same inventory section widget
          // You can customize this as needed
          // InventoryScreen().buildInventorySection(context, 'Search Results', searchResults),
        ],
      ),
    );
  }
}
