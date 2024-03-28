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

  @override
  Widget build(BuildContext context) {
    orderController.updateData.value = updateData;
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
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: 
                          DataTable(
                            columnSpacing: 16.0, // Adjust the spacing between columns
                            horizontalMargin: 16.0, // Adjust the horizontal margin
                            columns: [
                              DataColumn(label: Text('Order ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Customer', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Customer ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Product', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Product ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Order Date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Total Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
                              DataColumn(label: Text('Order by', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),),
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

  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
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