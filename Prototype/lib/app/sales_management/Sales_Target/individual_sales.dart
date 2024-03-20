import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/models/user_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';


class IndividualSalesScreen extends StatefulWidget {
  const IndividualSalesScreen({super.key});

  @override
  State<IndividualSalesScreen> createState() => _IndividualSalesScreenState();
}

class _IndividualSalesScreenState extends State<IndividualSalesScreen> {
  int _selectedMonth = 0; // Default to "Total"
  int _selectedYear = DateTime.now().year;
  final RequestUtil requestUtil = RequestUtil();

  List<String> monthNames = [
    'Total', // Add "Total" as the first option
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Employee Monthly Sales'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    items: List<DropdownMenuItem<int>>.generate(9, (int index) {
                      int year = DateTime.now().year - 3 + index;
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                  ),
                ],
              ),
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
                    items: List.generate(monthNames.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(monthNames[index]),
                      );
                    }),
                  ),
                ],
              ),
              // Add a GridView for buttons
              const SizedBox(height: 40.0),
              employeeStats(_selectedMonth, _selectedYear),
              // IndividualSales(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget employeeStats(int selectedMonth, int selectedYear) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Employee Sales', style: TextStyle(fontSize: 20),),
        const Divider(),
        FutureBuilder(
          future: _fetchEmployeeStats(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 26.0),
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Unable to load employee sales",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              List<User> data = snapshot.data as List<User>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DataTable(
                    columnSpacing: 20.0, // 调整列之间的间距
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Employee',
                          style: TextStyle(fontSize: 14), // 调整字体大小
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Sales',
                          style: TextStyle(fontSize: 14), // 调整字体大小
                        ),
                      ), // 添加差值列
                    ],
                    rows: data.map((user) {
                      print(_selectedMonth);
                      if (_selectedMonth == 0){
                        if (user.salesRecord.isNotEmpty){
                          dynamic total = 0;
                          for (int i = 0; i < user.salesRecord.length; i++){
                            if (user.salesRecord[i].year == _selectedYear){
                              total += user.salesRecord[i].sales;
                            }
                          }
                          return DataRow(
                            cells: [
                              DataCell(Text(user.employeeName)),
                              DataCell(Text(total.toStringAsFixed(2))),
                            ],
                          );
                        }
                        else {
                          return DataRow(cells: [
                            DataCell(Text(user.employeeName)),
                            const DataCell(Text('-')),
                          ]);
                        }
                      }
                      else {
                        if (user.salesRecord.isNotEmpty){
                          for (int i = 0; i < user.salesRecord.length; i++){
                            if (user.salesRecord[i].month == selectedMonth && user.salesRecord[i].year == _selectedYear){
                              return DataRow(
                                cells: [
                                  DataCell(Text(user.employeeName)),
                                  DataCell(Text(user.salesRecord[i].sales.toStringAsFixed(2))),
                                ],
                              );
                            }
                          }
                          return DataRow(cells: [
                            DataCell(Text(user.employeeName)),
                            const DataCell(Text('-')), 
                          ]);
                        }
                        else {
                          return DataRow(cells: [
                            DataCell(Text(user.employeeName)),
                            const DataCell(Text('-')),
                          ]);
                        }
                      }
                    }).toList(),
                  )
                ]
              );
            }
            else {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Unable to load employee sales",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }
  
  Future<List<User>> _fetchEmployeeStats() async {
    final response = await requestUtil.getUsers();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<User> result = data.map((data) => User.fromJson(data)).toList();
      return result;
    }
    else {
      throw Exception('Failed to load employee sales');
    }
  }
}

