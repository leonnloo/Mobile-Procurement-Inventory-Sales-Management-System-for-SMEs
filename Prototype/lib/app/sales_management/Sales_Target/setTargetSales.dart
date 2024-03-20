// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';

class SetSalesTargetScreen extends StatefulWidget {
  const SetSalesTargetScreen({super.key});

  @override
  SetSalesTargetScreenState createState() => SetSalesTargetScreenState();
}

class SetSalesTargetScreenState extends State<SetSalesTargetScreen> {
  // 定义变量来存储用户输入的目标值
  double _monthlyTarget = 0.0;
  final _formKey = GlobalKey<FormState>();
  int _selectedMonth = DateTime.now().month;
  final RequestUtil requestUtil = RequestUtil();
  int _selectedYear = int.parse(DateTime.now().year.toString());

  List<String> monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Set Sales Target'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Year',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DropdownButton<int>(
                  value: _selectedYear,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(6, (int index) {
                    int year = DateTime.now().year + index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Month',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                DropdownButton<int>(
                  value: _selectedMonth,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                  },
                  items: List.generate(12, (index) {
                    int monthValue = index + 1; // Months are 1-indexed
                    String monthName = monthNames[index]; // Get the name of the month
                    return DropdownMenuItem<int>(
                      value: monthValue,
                      child: Text(monthName),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Set Monthly Target',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                final response = await requestUtil.setMonthlyTarget(_selectedYear, _selectedMonth, _monthlyTarget);
                if (response.statusCode == 200) {  
                  // 弹出对话框显示目标设置成功
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: Text('Sales target set successfully for $_selectedMonth.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 关闭对话框
                              Navigator.pop(context); // 返回上一个页面
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Target added failed: ${jsonDecode(response.body)['detail']}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 15.0)
              ),
              child: const Text('Save Target'),
            ),
          ],
        ),
      ),
    );
  }
}
