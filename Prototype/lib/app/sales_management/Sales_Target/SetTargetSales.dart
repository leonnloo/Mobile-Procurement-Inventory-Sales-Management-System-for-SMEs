import 'package:flutter/material.dart';

class SetSalesTargetScreen extends StatefulWidget {
  @override
  _SetSalesTargetScreenState createState() => _SetSalesTargetScreenState();
}

class _SetSalesTargetScreenState extends State<SetSalesTargetScreen> {
  // 定义变量来存储用户输入的目标值
  double _monthlyTarget = 0.0;
  String _selectedMonth = 'January'; // 默认选择一月

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Sales Target',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        elevation: 0, // 移除阴影
        centerTitle: true, // 标题居中
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Month',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            DropdownButton<String>(
              value: _selectedMonth,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMonth = newValue!;
                });
              },
              items: <String>[
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Set Monthly Target',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Monthly Target',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on), // 添加货币图标
              ),
              onChanged: (value) {
                setState(() {
                  // 将用户输入的值更新到变量中
                  _monthlyTarget = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // 在此处添加保存目标的逻辑，可以将目标保存到数据库或其他持久化存储中
                //Connect with backend

                // 这里仅打印目标值作为示例
                print('Month: $_selectedMonth');
                print('Monthly Target: $_monthlyTarget');
                // 弹出对话框显示目标设置成功
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Sales target set successfully for $_selectedMonth.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // 关闭对话框
                            Navigator.pop(context); // 返回上一个页面
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Save Target'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0), // 调整按钮垂直内边距
                textStyle: TextStyle(fontSize: 18.0), // 调整按钮文字大小
              ),
            ),
          ],
        ),
      ),
    );
  }
}
