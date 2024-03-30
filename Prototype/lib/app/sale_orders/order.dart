import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:prototype/app/sale_orders/add_order.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/app/sale_orders/order_info.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/util/request_util.dart';


class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({super.key});

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  final RequestUtil requestUtil = RequestUtil();
  final orderController = Get.put(OrderController());
  String? _selectedFilter = 'Order ID';

  @override
  Widget build(BuildContext context) {
    orderController.updateData.value = updateData;
    orderController.updateFilter.value = updateFilter;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: GestureDetector(
                  onTap: () {
                    showSearch(context: context, delegate: OrderSearch(orderController.currentOrderList.value!));
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
            FutureBuilder(
              key: futureBuilderKey,
              future: orderController.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: double.infinity,
                      height: size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 26.0),
                          CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Theme.of(context).colorScheme.onSurface,
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
                      height: size.height * 0.8,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to load order data",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<SalesOrder> orders = snapshot.data as List<SalesOrder>;
                    orders = _fetchAndFilterOrders(orders);
                    Function update = orderController.updateFilter.value!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: 
                          DataTable(
                            columnSpacing: 16.0, // Adjust the spacing between columns
                            horizontalMargin: 16.0, // Adjust the horizontal margin
                            columns: [
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Order ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                    Icon(
                                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                                onSort: (columnIndex, ascending) {
                                  ascending = trackAscending;
                                  trackAscending = !ascending;
                                  update('Order ID');
                                },
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Customer', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                    Icon(
                                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                                onSort: (columnIndex, ascending) {
                                  ascending = trackAscending;
                                  trackAscending = !ascending;
                                  update('Customer');
                                },
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Customer ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                    Icon(
                                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                                onSort: (columnIndex, ascending) {
                                  ascending = trackAscending;
                                  trackAscending = !ascending;
                                  update('Customer ID');
                                },
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Product', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                    Icon(
                                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                                onSort: (columnIndex, ascending) {
                                  ascending = trackAscending;
                                  trackAscending = !ascending;
                                  update('Product');
                                },
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Product ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                    Icon(
                                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                                onSort: (columnIndex, ascending) {
                                  ascending = trackAscending;
                                  trackAscending = !ascending;
                                  update('Product ID');
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
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text('Order by', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                    Icon(
                                      trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ],
                                ),
                                onSort: (columnIndex, ascending) {
                                  ascending = trackAscending;
                                  trackAscending = !ascending;
                                  update('Employee');
                                },
                              ),
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
                                    Text(order.unitPrice.toStringAsFixed(2)),
                                    onTap: () {
                                      navigateToOrderDetail(context, order);
                                    },
                                  ),
                                  DataCell(
                                    Text(order.totalPrice.toStringAsFixed(2)),
                                    onTap: () {
                                      navigateToOrderDetail(context, order);
                                    },
                                  ),
                                  DataCell(
                                    Text(order.orderStatus),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to load order data",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddOrderScreen(updateData: updateData,),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  bool trackAscending = false;

  List<SalesOrder> _fetchAndFilterOrders(List<SalesOrder> orders) {
    if (_selectedFilter == null) {
      return [];
    } else {
      switch (_selectedFilter) {
        case 'Order ID':
          return orders
            ..sort((a, b) {
              int idA = int.parse(a.orderID.substring(2)); // Extract numeric part from orderID
              int idB = int.parse(b.orderID.substring(2));
              return trackAscending ? idA.compareTo(idB) : idB.compareTo(idA);
            });
        case 'Order Date':
        return orders..sort((a, b) {
            DateTime dateA = DateTime.parse(a.orderDate);
            DateTime dateB = DateTime.parse(b.orderDate);
            return trackAscending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
          });
        case 'Customer ID':
          return orders
            ..sort((a, b) {
              int idA = int.parse(a.customerID.substring(2)); // Extract numeric part from customerID
              int idB = int.parse(b.customerID.substring(2));
              return trackAscending ? idA.compareTo(idB) : idB.compareTo(idA);
            });          
        case 'Customer':
          return orders..sort((a, b) => trackAscending ? a.customerName.toLowerCase().compareTo(b.customerName.toLowerCase()) : b.customerName.toLowerCase().compareTo(a.customerName.toLowerCase()));
        case 'Product ID':
          return orders
            ..sort((a, b) {
              int idA = int.parse(a.productID.substring(2)); // Extract numeric part from productID
              int idB = int.parse(b.productID.substring(2));
              return trackAscending ? idA.compareTo(idB) : idB.compareTo(idA);
            });          
        case 'Product':
          return orders..sort((a, b) => trackAscending ? a.productName.toLowerCase().compareTo(b.productName.toLowerCase()) : b.productName.toLowerCase().compareTo(a.productName.toLowerCase()));
        case 'Quantity':
          return orders..sort((a, b) => trackAscending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));
        case 'Unit Price':
          return orders..sort((a, b) => trackAscending ? a.unitPrice.compareTo(b.unitPrice) : b.unitPrice.compareTo(a.unitPrice));
        case 'Total Price':
          return orders..sort((a, b) => trackAscending ? a.totalPrice.compareTo(b.totalPrice) : b.totalPrice.compareTo(a.totalPrice));
        case 'Status':
          return orders..sort((a, b) => trackAscending ? a.orderStatus.compareTo(b.orderStatus) : b.orderStatus.compareTo(a.orderStatus));
        case 'Employee':
          return orders..sort((a, b) => trackAscending ? a.employee.toLowerCase().compareTo(b.employee.toLowerCase()) : b.employee.toLowerCase().compareTo(a.employee.toLowerCase()));
        default:
          return orders;
      }
    }
  }

  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    if (mounted) {
      setState(() {
        futureBuilderKey = UniqueKey();
      });
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
class OrderSearch extends SearchDelegate<String> {
  OrderSearch(this.salesList);
  List<SalesOrder> salesList;
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<SalesOrder> suggestionList = query.isEmpty
    ? []
    : salesList.where((item) {
        // Adjusted to match the SalesOrder properties
        final searchableString = '${item.orderID} ${item.orderDate} ${item.customerID} '
            '${item.customerName} ${item.productID} ${item.productName} ${item.quantity} '
            '${item.unitPrice} ${item.totalPrice} ${item.completionStatus} '
            '${item.orderStatus} ${item.employee} ${item.employeeID}'.toLowerCase();

        return searchableString.contains(query.toLowerCase());
    }).toList();


    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
            final SalesOrder item = suggestionList[index];
            return ListTile(
                title: Text(item.productName),
                subtitle: Text('Order ID: ${item.orderID} - Total Price: ${item.totalPrice}'),
                onTap: () {
                    navigateToOrderDetail(context, item);
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
