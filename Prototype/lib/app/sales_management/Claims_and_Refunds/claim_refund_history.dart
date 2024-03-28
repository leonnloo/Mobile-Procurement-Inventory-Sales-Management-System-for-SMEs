import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/get_refunds.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/refund_info.dart';
import 'package:prototype/models/refund_model.dart'; // 导入退款数据模型

class ClaimRefundHistoryScreen extends StatefulWidget {
  const ClaimRefundHistoryScreen({super.key}); 
  @override
  State<ClaimRefundHistoryScreen> createState() => _ClaimRefundHistoryScreenState();
}

class _ClaimRefundHistoryScreenState extends State<ClaimRefundHistoryScreen> {
 // 修正构造函数
  Key futureBuilderKey = UniqueKey();
  List<Refunds> refunds = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        centerTitle: true,
        title: Text('Orders', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: _RefundsSearch(refunds, updateData));
            },
          )
        ],
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
      ),
      body: FutureBuilder(
        future: fetchRefundData(),
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
                      color: Theme.of(context).colorScheme.error,
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Unable to load refund data",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                width: double.infinity,
                height: size.height * 0.8,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No refund found",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              );
            } else {
              refunds = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: refunds.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(context, refunds[index]);
                  },
                ),
              );
            }
        }
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Refunds item) { // 修改为RefundData类型
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Customer : ${item.customerName}'), // 修改为顾客姓名
        subtitle: Text('Date: ${item.refundDate} | Total Refunded: ${item.refundAmount.toStringAsFixed(2)}'),
        onTap: () {
          navigateToRefundDetail(context, item); // 修改为跳转到退款详情页
        },
      ),
    );
  }

  void navigateToRefundDetail(BuildContext context, Refunds item) { // 修改为RefundData类型
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RefundDetailScreen(item: item, updateData: updateData,), // 修改为跳转到退款详情页
      ),
    );
  }
  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}

class _RefundsSearch extends SearchDelegate<String> {
  _RefundsSearch(this.refunds, this.updateData);
  final Function updateData;
  final List<Refunds> refunds;

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter the flattened list based on the query across all fields
    final List<Refunds> suggestionList = query.isEmpty
        ? []
        : refunds.where((order) {
            // Combine all fields into a single searchable string.
            // Make sure to call toString() on non-string fields and use toLowerCase() for case-insensitive matching
            final searchableString = '${order.orderID} ${order.refundDate} ${order.customerID} ${order.customerName} '
                '${order.productID} ${order.productName} ${order.refundQuantity} ${order.refundID} ${order.refundAmount} '
                '${order.reason}'.toLowerCase();
            
            return searchableString.contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final Refunds item = suggestionList[index];
        return ListTile(
          title: Text('Order No: ${item.orderID}'),
          subtitle: Text('Customer: ${item.customerName} - ${item.refundDate}'),
          onTap: () {
            navigateToRefundDetail(context, item, updateData);
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

