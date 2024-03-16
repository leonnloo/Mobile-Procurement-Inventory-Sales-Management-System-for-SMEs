import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Sales_Target/IndividualSales.dart';
import 'package:prototype/app/sales_management/Sales_Target/SalesByDate.dart';
import 'package:prototype/app/sales_management/Sales_Target/SetTargetSales.dart';

import 'SalesComparisonChart.dart';



class SalesTargetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Target'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildButtonWithIcon(
              onPressed: () {
                // 导航到目标销售页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetSalesTargetScreen() ),
                );
              },
              icon: Icons.bar_chart_outlined,
              label: 'Set Target Sales',
            ),
            SizedBox(height: 20.0),
            _buildButtonWithIcon(
              onPressed: () {
                // 导航到月度利润和损失页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>SalesComparisonScreen() ),
                );
              },
              icon: Icons.trending_up,
              label: 'Actual vs Target - Month',
            ),
            SizedBox(height: 20.0),
            _buildButtonWithIcon(
              onPressed: () {
                // 导航到按日期销售页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesByDate() ),
                );
              },
              icon: Icons.calendar_today,
              label: 'Sales by Date',
            ),
            SizedBox(height: 20.0),
            _buildButtonWithIcon(
              onPressed: () {
                // 导航到个人员工销售页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IndividualSalesScreen() ),
                );
              },
              icon: Icons.person,
              label: 'Individual Employee Sales',
            ),
            SizedBox(height: 20.0),
            _buildButtonWithIcon(
              onPressed: () {
                // 显示帮助信息
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Help'),
                      content: Text('If you need assistance, please contact 18069030677.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icons.help,
              label: 'Get Help',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithIcon({required VoidCallback onPressed, required IconData icon, required String label}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 30.0),
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          label,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.white,
        padding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
