import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/sale_orders/order_info.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/util/management_util.dart';
import 'package:prototype/util/request_util.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  List<SalesOrder> dispatchData;
  final String selectedStatus;
  DetailScreen({super.key, required this.dispatchData, required this.selectedStatus});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final RequestUtil requestUtil = RequestUtil();
  final orderController = Get.put(OrderController());

  final ManagementUtil managementUtil = ManagementUtil();
  @override
  Widget build(BuildContext context) {
    orderController.updateDispatchDetailData.value = updateData;
    // 根据订单状态分类
    Map<String, List<SalesOrder>> groupedData = {};
    groupedData['To be Packaged'] = [];
    groupedData['To be Shipped'] = [];
    groupedData['To be Delivered'] = [];
    groupedData['Delivered'] = [];
    for (var data in widget.dispatchData) {
      groupedData[data.completionStatus]?.add(data);
    }

    return DefaultTabController(
      length: groupedData.keys.length,
      initialIndex: _getInitialIndex(groupedData.keys.toList(), widget.selectedStatus),
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 60.0,
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text('Orders', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Function update = orderController.updateDispatchMenuData.value!;
                update();
                Navigator.of(context).pop(); // This will pop the current screen off the navigation stack.
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: _DataSearch(groupedData));
                },
              )
            ],
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
          ),
        body: Column(
          children: <Widget>[
            // Style this Container to match your AppBar if needed
            TabBar(
              isScrollable: true, // This needs to be true for long labels
              labelColor: Theme.of(context).colorScheme.onSurface,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              labelPadding: const EdgeInsets.all(10),
              tabAlignment: TabAlignment.start,
              tabs: groupedData.keys.map((status) => Tab(text: status)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: groupedData.keys.map((status) {
                  return ListView.builder(
                    itemCount: groupedData[status]!.length,
                    itemBuilder: (context, index) {
                      final reverseIndex = groupedData[status]!.length - 1 - index;
                      return _buildListItem(context, groupedData[status]![reverseIndex]);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildListItem(BuildContext context, SalesOrder order) {
    final size = MediaQuery.of(context).size;
    bool deliveredButton = true;
    if (order.completionStatus == 'Delivered') {
      deliveredButton = false;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        elevation: 4.0,
        shadowColor: Colors.grey.withOpacity(0.5), // Shadow color with some transparency
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Adjusted horizontal margin
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 100, 163, 235), Color.fromARGB(255, 92, 100, 216)], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners for the container
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(
                'Order ID: ${order.orderID}',
                style: TextStyle(color: Theme.of(context).colorScheme.surface), // Text color contrasting with the card's gradient
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Date: ${order.orderDate}', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                  Text('Customer ID: ${order.customerID}', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                  Text('Product ID: ${order.productID}', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                  Text('Status: ${order.completionStatus}', style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                ],
              ),
              onTap: () {
                navigateToOrderDetail(context, order); // Navigate to order detail page
              },
              // Adding a button on the right side of the card
              trailing: SizedBox(
                width: size.width * 0.25,
                height: 50.0,
                child: deliveredButton ? IconButton(
                  icon: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.surface, size: 30,), // Icon color
                  onPressed: () async {
                    String completionStatus = '';
                    if (order.completionStatus == 'To be Packaged') {
                      completionStatus = 'To be Shipped';
                    } else if (order.completionStatus == 'To be Shipped') {
                      completionStatus = 'To be Delivered';
                    } else if (order.completionStatus == 'To be Delivered') {
                      completionStatus = 'Delivered';
                    }
                    final response = await managementUtil.updateDispatch(order.orderID, completionStatus);
                    if (response.statusCode == 200) {
                      Function update = orderController.updateDispatchMenuData.value!;
                      orderController.clearOrders();
                      orderController.getOrders;
                      update();
                      final List<SalesOrder> updatedDispatchData = await _fetchSalesOrderData();
                      setState(() {
                        widget.dispatchData = updatedDispatchData;
                      });
                    }
                  },
                ) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getInitialIndex(List<String> statusList, String? initialStatus) {
    if (initialStatus != null) {
      String initialStatusLower = initialStatus.toLowerCase(); // 将初始状态转换为小写
      for (int i = 0; i < statusList.length; i++) {
        if (statusList[i].toLowerCase() == initialStatusLower) { // 将状态列表中的每个状态转换为小写进行比较
          return i;
        }
      }
    }
    return 0; // 如果没有匹配到，返回默认索引为0
  }

  Future<List<SalesOrder>> _fetchSalesOrderData() async {
    final response = await requestUtil.getSaleOrders();
    if (response.statusCode == 200) {
      List<dynamic> orders = jsonDecode(response.body);
      List<SalesOrder> salesOrders = orders.map((e) => SalesOrder.fromJson(e)).toList();
      return salesOrders;
    } else {
      throw Exception('Error while fetching code');
    }
  }

  void updateData(){
    if (mounted) {
      setState(() {
      });
    }
  }
}
// Filter system
class _DataSearch extends SearchDelegate<String> {
  _DataSearch(this.groupedData);

  final Map<String, List<SalesOrder>> groupedData;

  @override
  Widget buildSuggestions(BuildContext context) {
    // Flatten all SalesOrder lists into a single list
    final allOrders = groupedData.values.expand((list) => list).toList();

    // Filter the flattened list based on the query across all fields
    final List<SalesOrder> suggestionList = query.isEmpty
        ? []
        : allOrders.where((order) {
            // Combine all fields into a single searchable string.
            // Make sure to call toString() on non-string fields and use toLowerCase() for case-insensitive matching
            final searchableString = '${order.orderID} ${order.orderDate} ${order.customerID} ${order.customerName} '
                '${order.productID} ${order.productName} ${order.quantity} ${order.unitPrice} ${order.totalPrice} '
                '${order.completionStatus} ${order.orderStatus} ${order.employee} ${order.employeeID}'.toLowerCase();
            
            return searchableString.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final SalesOrder item = suggestionList[index];
        return ListTile(
          title: Text('Order No: ${item.orderID}'),
          subtitle: Text('Customer: ${item.customerName} - ${item.completionStatus}'),
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
        toolbarHeight: 60
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 22),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 22),

      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 22),

      )
    );
  }
}



void navigateToOrderDetail(BuildContext context, SalesOrder order) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => OrderDetailScreen(order: order),
    ),
  );
}