import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/sale_orders/order_info.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/management_util.dart';
import 'package:prototype/util/request_util.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  List<SalesOrder> dispatchData;
  final String selectedStatus;
  final Function updateData;
  DetailScreen({super.key, required this.dispatchData, required this.selectedStatus, required this.updateData});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final RequestUtil requestUtil = RequestUtil();
  final ManagementUtil managementUtil = ManagementUtil();
  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.red[400],
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('Orders'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.updateData();
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
          ),
        body: Column(
          children: <Widget>[
            // Style this Container to match your AppBar if needed
            TabBar(
              isScrollable: true, // This needs to be true for long labels
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.red[400],
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
            gradient: LinearGradient(
              colors: [const Color.fromARGB(199, 248, 177, 177), Colors.red.shade300], // Gradient colors
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
                style: const TextStyle(color: Colors.black), // Text color contrasting with the card's gradient
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Date: ${order.orderDate}', style: TextStyle(color: Colors.black.withOpacity(0.9))),
                  Text('Customer ID: ${order.customerID}', style: TextStyle(color: Colors.black.withOpacity(0.9))),
                  Text('Product ID: ${order.productID}', style: TextStyle(color: Colors.black.withOpacity(0.9))),
                  Text('Status: ${order.completionStatus}', style: TextStyle(color: Colors.black.withOpacity(0.9))),
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
                  icon: const Icon(Icons.check_circle_outline, color: Colors.black, size: 30,), // Icon color
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
    setState(() {
      
    });
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
}



void navigateToOrderDetail(BuildContext context, SalesOrder item) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ItemDetailScreen(item: item),
    ),
  );
}