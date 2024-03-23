import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Sales_Target/individual_sales.dart';
import 'package:prototype/app/sales_management/Sales_Target/set_target_sales.dart';
import 'package:prototype/app/sales_management/Sales_Target/sales_comparison_chart.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/icon_button.dart';



class SalesTargetScreen extends StatelessWidget {
  const SalesTargetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Sales Target'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButtonWithIcon(
              onPressed: () {
                // 导航到目标销售页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetSalesTargetScreen() ),
                );
              },
              icon: Icons.bar_chart_outlined,
              label: 'Set Target Sales',
            ),
            const SizedBox(height: 20.0),
            buildButtonWithIcon(
              onPressed: () {
                // 导航到月度利润和损失页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SalesComparisonScreen() ),
                );
              },
              icon: Icons.trending_up,
              label: 'Sales by Month',
            ),
            const SizedBox(height: 20.0),
            
            const SizedBox(height: 20.0),
            buildButtonWithIcon(
              onPressed: () {
                // 导航到个人员工销售页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IndividualSalesScreen() ),
                );
              },
              icon: Icons.person,
              label: 'Individual Employee Sales',
            ),
            const SizedBox(height: 20.0),
            buildButtonWithIcon(
              onPressed: () {
                // 显示帮助信息
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Help'),
                      content: const Text('If you need assistance, please contact 18069030677.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
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
}
