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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Sales Target'),
      body: SizedBox(
        height: size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      context: context
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
                      context: context
                    ),
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
                      context: context
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
                              content: const Text('If you need assistance, please contact GRP14@nottingham.edu.cn.'),
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
                      context: context
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
