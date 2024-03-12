import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/inventory/speed_dial_inventory.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/app/inventory/inventory_info.dart';
import 'package:prototype/util/request_util.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});
  final RequestUtil requestUtil = RequestUtil();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // In Stock Section
            buildInventorySection(context, 'In Stock'),
          
            // Low Stock Section
            buildInventorySection(context, 'Low Stock'),
        
            // Out of Stock Section
            buildInventorySection(context, 'Out of Stock'),
          ],
        ),
      ),
      floatingActionButton: inventorySpeedDial(context),
    );
  }

  Widget buildInventorySection(BuildContext context, String sectionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: _fetchInventoryData(sectionTitle),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
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
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Unable to load item data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              List<InventoryItem> items = snapshot.data as List<InventoryItem>;
              if (items.isNotEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sectionTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 16.0,
                        horizontalMargin: 16.0,
                        columns: const [
                          DataColumn(label: Text('Item ID')),
                          DataColumn(label: Text('Item')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Unit Price')),
                          DataColumn(label: Text('Total Price')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: items.map((InventoryItem item) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(item.itemID.toString()),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                              DataCell(
                                Text(item.itemName),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                              DataCell(
                                Text(item.category),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                              DataCell(
                                Text(item.quantity.toString()),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                              DataCell(
                                Text('\$${item.unitPrice.toStringAsFixed(2)}'),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                              DataCell(
                                Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                              DataCell(
                                Text(item.status),
                                onTap: () {
                                  navigateToItemDetail(context, item);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }
              else {
                return Container();
              }
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
                      "Unable to load inventory data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              );
            }
          }
        ),
      ],
    );
  }

  Future<List<InventoryItem>> _fetchInventoryData(String category) async {
    try {
      final item = await requestUtil.getInventoryType(category);
      if (item.statusCode == 200) {
        // Assuming the JSON response is a list of objects
        List<dynamic> jsonData = jsonDecode(item.body);
        
        // Map each dynamic object to InventoryItem
        List<InventoryItem> itemData = jsonData.map((data) => InventoryItem.fromJson(data)).toList();
        return itemData;
      } else {
        throw Exception('Unable to fetch item data.');
      }
    } catch (error) {
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
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
        .where((item) =>
            item.itemName.toLowerCase().contains(query.toLowerCase()))
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