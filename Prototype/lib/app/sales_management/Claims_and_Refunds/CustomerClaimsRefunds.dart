import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/ClaimRefundHistory.dart';
import '../../../models/refundData.dart';
import 'AddClaimRefundForm.dart'; // 导入添加 Claim 或 Refund 表单的页面

class CustomerClaimsRefundsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claims & Refunds'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // 导航到添加 Claim 或 Refund 表单页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddClaimRefundForm()),
                  );
                },
                icon: Icon(Icons.description, size: 30.0), // 表单图标
                label: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Submit Claim or Refund Form',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ), // 表单按钮文本
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton.icon(
                onPressed: () {
                  // 导航到查看历史记录页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClaimRefundHistoryScreen(history: refundData)),
                  );
                },
                icon: Icon(Icons.history, size: 30.0), // 历史记录图标
                label: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'View Claim and Refund History',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ), // 历史记录按钮文本
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton.icon(
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
                icon: Icon(Icons.help, size: 30.0), // 帮助图标
                label: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Get Help',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ), // 帮助按钮文本
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

