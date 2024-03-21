import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prototype/app/sales_management/product_monthly_sales.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';

class ProductSalesByMonth extends StatefulWidget {
  const ProductSalesByMonth({super.key});

  @override
  State<ProductSalesByMonth> createState() => _ProductSalesByMonthState();
}

class _ProductSalesByMonthState extends State<ProductSalesByMonth> {
  final RequestUtil requestUtil = RequestUtil();

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = 0; // Default to "Total"
  List<String> monthNames = [
    'Total', // Add "Total" as the first option
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Sales by Date'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add a GridView for buttons
              const SizedBox(height: 20.0),
              const Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ProductMonthlySalesLine1(),
                ),
              ),
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
              const SizedBox(height: 10,),
              const Divider(),
              const SizedBox(height: 10,),
              FutureBuilder(
                future: _fetchSalesTargetData(),
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
                            "Unable to load product sales",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No product sales found",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<ProductItem> data = snapshot.data as List<ProductItem>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Product Monthly Sales',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20.0, // 调整列之间的间距
                            columns: const [
                              DataColumn(
                                label: Text( 'ID', style: TextStyle(fontSize: 14),),
                              ),
                              DataColumn(
                                label: Text( 'Product', style: TextStyle(fontSize: 14),),
                              ),
                              DataColumn(
                                label: Text( 'Quantity \nSold', style: TextStyle(fontSize: 14),),
                              ),
                              DataColumn(
                                label: Text( 'Unit Price', style: TextStyle(fontSize: 14),),
                              ), // 添加差值列
                              DataColumn(
                                label: Text( 'Total Price', style: TextStyle(fontSize: 14),),
                              ), // 添加差值列
                            ],
                            rows: data.map((data) {
                              if (_selectedMonth == 0){
                                if (data.monthlySales.isNotEmpty){
                                  dynamic priceTotal = 0;
                                  dynamic quantityTotal = 0;
                                  for (int i = 0; i < data.monthlySales.length; i++){
                                    if (data.monthlySales[i].year == _selectedYear){
                                      priceTotal += data.monthlySales[i].totalPrice;
                                      quantityTotal += data.monthlySales[i].quantitySold;
                                    }
                                  }
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(data.productID)),
                                      DataCell(Text(data.productName)),
                                      DataCell(Text(quantityTotal.toString())),
                                      DataCell(Text(data.unitPrice.toStringAsFixed(2))),
                                      DataCell(Text(priceTotal.toStringAsFixed(2))),
                                    ],
                                  );
                                }
                                else {
                                  return DataRow(cells: [
                                    DataCell(Text(data.productID)),
                                    DataCell(Text(data.productName)),
                                    const DataCell(Text('-')),
                                    DataCell(Text(data.unitPrice.toStringAsFixed(2))),
                                    const DataCell(Text('-')),
                                  ]);
                                }
                              }
                              else {
                                if (data.monthlySales.isNotEmpty){
                                  for (int i = 0; i < data.monthlySales.length; i++){
                                    if (data.monthlySales[i].year == _selectedYear && data.monthlySales[i].month == _selectedMonth){
                                      return DataRow(cells: [
                                        DataCell(Text(data.productID)),
                                        DataCell(Text(data.productName)),
                                        DataCell(Text(data.monthlySales[i].quantitySold.toString())),
                                        DataCell(Text(data.unitPrice.toStringAsFixed(2))),
                                        DataCell(Text(data.monthlySales[i].totalPrice.toStringAsFixed(2))),
                                      ]);
                                    }
                                  }
                                  return DataRow(cells: [
                                    DataCell(Text(data.productID)),
                                    DataCell(Text(data.productName)),
                                    const DataCell(Text('-')),
                                    DataCell(Text(data.unitPrice.toStringAsFixed(2))),
                                    const DataCell(Text('-')),
                                  ]);
                                }
                                else {
                                  return DataRow(cells: [
                                    DataCell(Text(data.productID)),
                                    DataCell(Text(data.productName)),
                                    const DataCell(Text('-')),
                                    DataCell(Text(data.unitPrice.toStringAsFixed(2))),
                                    const DataCell(Text('-')),
                                  ]);
                                }
                              }
                            }).toList(),
                          ),
                        ),
                      ],
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
                            "Unable to load product sales",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<ProductItem>> _fetchSalesTargetData() async {
    final response = await requestUtil.getProducts();
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<ProductItem> result = data.map((data) => ProductItem.fromJson(data)).toList();
      return result;
    }
    else {
      throw Exception('Failed to load product sales');
    }
  }
}
