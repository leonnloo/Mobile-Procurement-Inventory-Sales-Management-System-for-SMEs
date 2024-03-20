import 'package:flutter/material.dart';
import 'package:prototype/models/refundData.dart'; // 导入退款数据模型

class ClaimRefundHistoryScreen extends StatelessWidget {
  final List<RefundData> history; // 修改为RefundData类型

  ClaimRefundHistoryScreen({Key? key, required this.history}) : super(key: key); // 修正构造函数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim and Refund History'),
        backgroundColor: Colors.red,
        actions: [ // 添加搜索框
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: _DataSearch(history));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            return _buildListItem(context, history[index]);
          },
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, RefundData item) { // 修改为RefundData类型
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Customer Name: ${item.customerName}'), // 修改为顾客姓名
        subtitle: Text('Date: ${item.date} | Status: ${item.status}'),
        onTap: () {
          navigateToRefundDetail(context, item); // 修改为跳转到退款详情页
        },
      ),
    );
  }

  void navigateToRefundDetail(BuildContext context, RefundData item) { // 修改为RefundData类型
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RefundDetailScreen(item: item), // 修改为跳转到退款详情页
      ),
    );
  }
}

class RefundDetailScreen extends StatelessWidget { // 修改类名为RefundDetailScreen
  final RefundData item; // 修改为RefundData类型

  const RefundDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refund Detail'), // 修改页面标题
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Customer Name', item.customerName), // 修改为顾客姓名
            _buildDetailRow('Customer ID', item.customerID.toString()),
            _buildDetailRow('Date', item.date),
            _buildDetailRow('Reason', item.reason),
            _buildDetailRow('Amount', '\$${item.amount.toString()}'),
            _buildDetailRow('Status', item.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}

// 实现搜索逻辑的类
class _DataSearch extends SearchDelegate<String> {
  final List<RefundData> history;

  _DataSearch(this.history);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = history.where((data) => data.customerName.toLowerCase().contains(query.toLowerCase())).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No information found.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].customerName),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RefundDetailScreen(item: results[index])),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? history
        : history.where((data) => data.customerName.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].customerName),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RefundDetailScreen(item: suggestionList[index])),
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search by Username'; // 搜索框提示文字
}
