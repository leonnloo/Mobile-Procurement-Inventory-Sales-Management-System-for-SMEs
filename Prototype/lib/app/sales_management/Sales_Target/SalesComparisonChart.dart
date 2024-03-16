import 'package:flutter/material.dart';

import '../../../models/SalesTargetData.dart';

class SalesComparisonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actual vs Target'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sales Comparison Table',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DataTable(
              columnSpacing: 20.0, // 调整列之间的间距
              columns: [
                DataColumn(
                  label: Text(
                    'Month',
                    style: TextStyle(fontSize: 14), // 调整字体大小
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actual \nSales',
                    style: TextStyle(fontSize: 14), // 调整字体大小
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Target \nSales ',
                    style: TextStyle(fontSize: 14), // 调整字体大小
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Difference',
                    style: TextStyle(fontSize: 14), // 调整字体大小
                  ),
                ), // 添加差值列
              ],
              rows: salesTargetData.map((data) {
                final difference = data.actualSalesVolume - data.targetSalesVolume;
                final differenceText = difference.toString();
                final differenceColor = difference < 0 ? Colors.red : null; // 若差值为负数则设置颜色为红色
                return DataRow(cells: [
                  DataCell(
                    Text(
                      data.month,
                      style: TextStyle(
                        fontSize: 14, // 调整字体大小
                        color: differenceColor, // 设置颜色为红色
                      ),
                    ),
                  ),
                  DataCell(Text(data.actualSalesVolume.toString())),
                  DataCell(Text(data.targetSalesVolume.toString())),
                  DataCell(
                    Text(
                      differenceText,
                      style: TextStyle(fontSize: 14, color: differenceColor), // 调整字体大小并设置颜色
                    ),
                  ), // 显示差值
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
