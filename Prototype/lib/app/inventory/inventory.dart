import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/inventory/speed_dial_inventory.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/app/inventory/inventory_info.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';
import 'package:prototype/util/request_util.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final RequestUtil requestUtil = RequestUtil();
  final inventoryController = Get.put(InventoryController());
  Map<String, List<InventoryItem>> groupedData = {};
  // Future<List<InventoryItem>>? inventoryFuture;

  @override
  void initState() {
    // inventoryFuture = inventoryController.getInventories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    inventoryController.updateData.value = updateData;  
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
                      showSearch(context: context, delegate: ItemSearch(groupedData));
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
              future: inventoryController.getInventories(),
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
        floatingActionButton: inventorySpeedDial(context),
      ),
    );
  }

  int? sortColumnIndex;
  bool sortAscending = true;

  Widget buildInventorySection(BuildContext context, List<InventoryItem> inventoryItems) {
    // dynamic getColumnValue(InventoryItem item, int columnIndex) {
    //   switch (columnIndex) {
    //     case 0:
    //       return item.itemID;
    //     case 1:
    //       return item.itemName;
    //     case 2:
    //       return item.category;
    //     case 3:
    //       return item.quantity;
    //     case 4:
    //       return item.unitPrice;
    //     case 5:
    //       return item.totalPrice;
    //     case 6:
    //       return item.status;
    //     default:
    //       return '';
    //   }
    // }

    // // Generic comparison function for dynamic types
    // int compareValues(bool ascending, dynamic value1, dynamic value2) {
    //   if (value1 is String && value2 is String) {
    //     return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
    //   } else if (value1 is int && value2 is int) {
    //     return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
    //   } else if (value1 is double && value2 is double) {
    //     return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
    //   } else {
    //     // Fallback for other types, if any
    //     return 0;
    //   }
    // }
    // void onSort(int columnIndex, bool ascending) {
    //   setState(() {
    //     sortColumnIndex = columnIndex;
    //     sortAscending = ascending;
    //     groupedData.forEach((key, value) {
    //       groupedData[key] = value..sort((a, b) {
    //         var aValue = getColumnValue(a, columnIndex);
    //         var bValue = getColumnValue(b, columnIndex);
    //         return compareValues(ascending, aValue, bValue);
    //       });
    //     });
    //   });
    // }

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16.0,
          horizontalMargin: 16.0,
          columns: [
            DataColumn(
              label: Text('Item ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
            DataColumn(label: Text('Item', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
            DataColumn(label: Text('Category', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
            DataColumn(label: Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
            DataColumn(label: Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
            DataColumn(label: Text('Total Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
            DataColumn(label: Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              // onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
            ),
          ],
          rows: inventoryItems.map((InventoryItem item) {
            return DataRow(
              cells: [
                DataCell(
                  Text(item.itemID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item);
                  },
                ),
                DataCell(
                  Text(item.itemName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item);
                  },
                ),
                DataCell(
                  Text(item.category, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item);
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
                    navigateToItemDetail(context, item);
                  },
                ),
                DataCell(
                  Text('\$${item.unitPrice.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item);
                  },
                ),
                DataCell(
                  Text('\$${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item);
                  },
                ),
                DataCell(
                  Text(item.status, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  onTap: () {
                    navigateToItemDetail(context, item);
                  },
                ),
              ],
            );
          }).toList(),
        )
      ),
    );
  }

  Key futureBuilderKey = UniqueKey();
  void updateData() async {
    if (mounted) {
    setState(() {
      // inventoryFuture = inventoryController.getInventories();
      futureBuilderKey = UniqueKey();
    });
  }
  }
  Color _getQuantityColor(int quantity, int safetyQuantity) {
    return quantity < safetyQuantity ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface;
  }
}



class ItemSearch extends SearchDelegate<String> {
  ItemSearch(this.groupedData);

  final Map<String, List<InventoryItem>> groupedData;

  @override
  Widget buildSuggestions(BuildContext context) {
    // Flatten all InventoryItem lists into a single list
    final allItems = groupedData.values.expand((list) => list).toList();

    // Filter the flattened list based on the query across all fields
    final List<InventoryItem> suggestionList = query.isEmpty
        ? []
        : allItems.where((item) {
            // Combine all fields into a single searchable string.
            // Make sure to call toString() on non-string fields and use toLowerCase() for case-insensitive matching
            final searchableString = '${item.itemID} ${item.itemName} ${item.category} ${item.quantity} '
                '${item.unitPrice} ${item.totalPrice} ${item.status}'.toLowerCase();
            
            return searchableString.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final InventoryItem item = suggestionList[index];
        return ListTile(
          title: Text(item.itemName),
          subtitle: Text('Category: ${item.category} - Quantity: ${item.quantity}'),
          onTap: () {
            navigateToItemDetail(context, item);
          },
        );
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  String get searchFieldLabel => 'Enter Query';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        color: Theme.of(context).colorScheme.onPrimaryContainer, // Change this to the desired color
        toolbarHeight: 80
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),

      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),

      )
    );
  }
}
