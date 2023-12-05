import 'package:flutter/material.dart';
import 'package:prototype/app/inventory/addinventory.dart';
import 'package:prototype/app/inventory/inventorydata.dart';
import 'package:prototype/app/inventory/inventoryinfo.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Filter inventory items into inStock, lowStock, and outOfStock lists
    List<InventoryItem> inStockItems = inventoryItems
        .where((item) => item.status == 'In Stock')
        .toList();

    List<InventoryItem> lowStockItems = inventoryItems
        .where((item) => item.status == 'Low Stock')
        .toList();

    List<InventoryItem> outOfStockItems = inventoryItems
        .where((item) => item.status == 'Out of Stock')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ItemSearch(inventoryItems));
            },
          ),
        ],
      ),
    
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // In Stock Section
            buildInventorySection(context, 'In Stock', inStockItems),

            // Low Stock Section
            buildInventorySection(context, 'Low Stock', lowStockItems),

            // Out of Stock Section
            buildInventorySection(context, 'Out of Stock', outOfStockItems),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddInventoryScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildInventorySection(BuildContext context, String sectionTitle, List<InventoryItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sectionTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
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
                    Text(item.itemName ?? 'N/A'),
                    onTap: () {
                      navigateToItemDetail(context, item);
                    },
                  ),
                  DataCell(
                    Text(item.category ?? 'N/A'),
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
                    Text('\$${item.unitPrice.toString()}'),
                    onTap: () {
                      navigateToItemDetail(context, item);
                    },
                  ),
                  DataCell(
                    Text('\$${item.totalPrice.toString()}'),
                    onTap: () {
                      navigateToItemDetail(context, item);
                    },
                  ),
                  DataCell(
                    Text(item.status ?? 'N/A'),
                    onTap: () {
                      navigateToItemDetail(context, item);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ItemSearch extends SearchDelegate<InventoryItem> {
  final List<InventoryItem> items;

  ItemSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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

    return SingleChildScrollView(
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