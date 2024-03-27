import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'detail_screen.dart';

class DispatchDeliveryScreen extends StatefulWidget {
  const DispatchDeliveryScreen({super.key});

  @override
  DispatchDeliveryScreenState createState() => DispatchDeliveryScreenState();
}

class DispatchDeliveryScreenState extends State<DispatchDeliveryScreen> {
  late int packagedCount;
  late int shippedCount;
  late int deliveredCount;
  late List<SalesOrder> orderData;
  final RequestUtil requestUtil = RequestUtil();
  Key futureBuilderKey = UniqueKey();

  @override
  void initState() {
    packagedCount = 0;
    shippedCount = 0;
    deliveredCount = 0;
    super.initState();
  }

  void countOrders(List<SalesOrder> saleOrders) {
    packagedCount = 0;
    shippedCount = 0;
    deliveredCount = 0;
    for (var data in saleOrders) {
      if (data.completionStatus == 'To be Packaged') {
        packagedCount++;
      } else if (data.completionStatus == 'To be Shipped') {
        shippedCount++;
      } else if (data.completionStatus == 'To be Delivered') {
        deliveredCount++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Dispatch and Delivery'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
              key: futureBuilderKey,
              future: _fetchSalesOrderData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: size.height * 0.8,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 26.0),
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Loading...',
                          style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: size.height * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildItem(context, [], '10\nQuantasdity to be Packaged', Icons.shopping_cart, 'To be Packaged', packagedCount),
                        const SizedBox(height: 20.0),
                        _buildItem(context, [], '10\nPackages to be Shipped', Icons.local_shipping, 'To be Shipped', shippedCount),
                        const SizedBox(height: 20.0),
                        _buildItem(context, [], '10\nPackages to be Delivered', Icons.delivery_dining, 'To be Delivered', deliveredCount),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return SizedBox(
                    height: size.height * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildItem(context, [], '10\nQuantasdity to be Packaged', Icons.shopping_cart, 'To be Packaged', packagedCount),
                        const SizedBox(height: 20.0),
                        _buildItem(context, [], '10\nPackages to be Shipped', Icons.local_shipping, 'To be Shipped', shippedCount),
                        const SizedBox(height: 20.0),
                        _buildItem(context, [], '10\nPackages to be Delivered', Icons.delivery_dining, 'To be Delivered', deliveredCount),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<SalesOrder> salesData = snapshot.data as List<SalesOrder>;
                      orderData = salesData;
                      countOrders(salesData);
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        _buildItem(context, salesData, '10\nQuantity to be Packaged', Icons.shopping_cart, 'To be Packaged', packagedCount),
                        const SizedBox(height: 20.0),
                        _buildItem(context, salesData, '10\nPackages to be Shipped', Icons.local_shipping, 'To be Shipped', shippedCount),
                        const SizedBox(height: 20.0),
                        _buildItem(context, salesData, '10\nPackages to be Delivered', Icons.delivery_dining, 'To be Delivered', deliveredCount),
                        const Spacer(),
                        Text(
                          'Total Orders Ongoing: ${packagedCount+shippedCount+deliveredCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                else{
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Unable to load dispatch data",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }

  Widget _buildItem(BuildContext context, List<SalesOrder> orderList, String title, IconData iconData, String status, int count) {
    return ElevatedButton.icon(
      onPressed: () {
        _navigateToDetail(context, orderList, title, status);
      },
      icon: Icon(
        iconData,
        color: Colors.black,
        size: 30.0,
      ),
      label: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          title.replaceAll('10', count.toString()), // Replacing '10' with the actual count
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _navigateToDetail(BuildContext context, List<SalesOrder> orderList, String itemName, String initialStatus) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(dispatchData: orderList, selectedStatus: initialStatus, updateData: updateData,), // 传递 searchResults
      ),
    );
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

}


