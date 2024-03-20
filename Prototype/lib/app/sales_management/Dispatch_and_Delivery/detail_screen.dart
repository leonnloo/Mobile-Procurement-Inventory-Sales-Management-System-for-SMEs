import 'package:flutter/material.dart';
import 'package:prototype/models/dispatch_data.dart'; // 导入订单数据模型

class DetailScreen extends StatelessWidget {
  final List<DispatchData> dispatchData;
  final initialStatus;

  const DetailScreen({Key? key, required this.dispatchData, this.initialStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 根据订单状态分类
    Map<String, List<DispatchData>> groupedData = {};
    for (var data in dispatchData) {
      if (!groupedData.containsKey(data.status)) {
        groupedData[data.status] = [];
      }
      groupedData[data.status]?.add(data);
    }

    return DefaultTabController(
      length: groupedData.keys.length,
      initialIndex: _getInitialIndex(groupedData.keys.toList(), initialStatus), // 使用函数获取初始索引
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Detail'), // 修改页面标题
          bottom: TabBar(
            tabs: groupedData.keys.map((status) => Tab(text: status)).toList(),
          ),
        ),
        body: TabBarView(
          children: groupedData.keys.map((status) {
            return ListView.builder(
              itemCount: groupedData[status]!.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, groupedData[status]![index]);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DispatchData item) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Order No: ${item.orderNo}'), // 修改为订单号
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${item.date}'),
            Text('Customer ID: ${item.customerID}'),
            Text('Product ID: ${item.productID}'),
            Text('Status: ${item.status}'),
          ],
        ),
        onTap: () {
          navigateToOrderDetail(context, item); // 修改为跳转到订单详情页
        },
      ),
    );
  }

  void navigateToOrderDetail(BuildContext context, DispatchData item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(item: item), // 修改为跳转到订单详情页
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

}

class OrderDetailScreen extends StatelessWidget {
  final DispatchData item;

  const OrderDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Order No', item.orderNo.toString()),
            _buildDetailRow('Date', item.date),
            _buildDetailRow('Customer ID', item.customerID.toString()),
            _buildDetailRow('Product ID', item.productID.toString()),
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
