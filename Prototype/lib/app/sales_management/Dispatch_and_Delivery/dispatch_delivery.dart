import 'package:flutter/material.dart';
import 'package:prototype/models/dispatch_data.dart';
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
  late List<DispatchData> searchResults;

  @override
  void initState() {
    super.initState();
    packagedCount = 0;
    shippedCount = 0;
    deliveredCount = 0;
    searchResults = [];
    countOrders();
  }

  void countOrders() {
    for (var data in dispatchData) {
      if (data.status == 'Packaged') {
        packagedCount++;
      } else if (data.status == 'Shipped') {
        shippedCount++;
      } else if (data.status == 'Delivered') {
        deliveredCount++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispatch & Delivery'),
        backgroundColor: Colors.red,
        actions: [ // 添加搜索框
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: _DataSearch());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: searchResults.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildItem(context, '10\nQuantity to be Packaged', Icons.shopping_cart, 'PACKAGED', packagedCount),
                  const SizedBox(height: 20.0),
                  _buildItem(context, '10\nPackages to be Shipped', Icons.local_shipping, 'SHIPPED', shippedCount),
                  const SizedBox(height: 20.0),
                  _buildItem(context, '10\nPackages to be Delivered', Icons.delivery_dining, 'DELIVERED', deliveredCount),
                ],
              )
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return _buildItem(
                    context,
                    'Order No: ${searchResults[index].orderNo}',
                    Icons.shopping_cart, // or use appropriate icon based on status
                    searchResults[index].status, // Use searchResults[index] to access status
                    1, // Assuming you want to show only 1 item for each search result
                  );
                },
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'In Summary: Total Orders: ${dispatchData.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, IconData iconData, String status, int count) {
    return ElevatedButton.icon(
      onPressed: () {
        _navigateToDetail(context, title, status);
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

  void _navigateToDetail(BuildContext context, String itemName, String initialStatus) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen( dispatchData: dispatchData, initialStatus: initialStatus,), // 传递 searchResults
      ),
    );
  }

  void searchOrders(String query) {
    setState(() {
      searchResults.clear();
      if (dispatchData != null) { // Checking if dispatchData is not null
        for (var data in dispatchData) {
          if (data.orderNo.toString().contains(query)) {
            searchResults.add(data);
          }
        }
      }
    });
  }
}


//Filter system
class _DataSearch extends SearchDelegate<String> {
  @override
  Widget buildSuggestions(BuildContext context) {
    // Placeholder implementation
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Search logic implementation
    final List<DispatchData> searchResults = dispatchData.where((data) => data.orderNo.toString() == query).toList();

    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No information found.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final DispatchData item = searchResults[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              'Order No: ${item.orderNo}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Date: ${item.date}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customer ID: ${item.customerID}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Product ID: ${item.productID}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${item.status}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
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
  String get searchFieldLabel => 'Enter Order No'; // 提示用户输入订单号
}


