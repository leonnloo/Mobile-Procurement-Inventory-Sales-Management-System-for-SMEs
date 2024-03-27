import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/claim_refund_history.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/icon_button.dart';
import 'add_claim_refund_form.dart'; // 导入添加 Claim 或 Refund 表单的页面

class CustomerClaimsRefundsScreen extends StatelessWidget {
  const CustomerClaimsRefundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Claims and Refunds'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildButtonWithIcon(
                onPressed: () {
                  // 导航到个人员工销售页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddClaimRefundForm() ),
                  );
                },
                icon: Icons.description,
                label: 'Submit New Refund Form',
              context: context
              ),
              const SizedBox(height: 40.0),
              buildButtonWithIcon(
                onPressed: () {
                  // 导航到个人员工销售页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClaimRefundHistoryScreen() ),
                  );
                },
                icon: Icons.history,
                label: 'View Refund History',
              context: context
              ),
              const SizedBox(height: 40.0),
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
    );
  }
}

