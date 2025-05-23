import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/sales_management/Sales_Target/edit_sales_target.dart';
import 'package:prototype/models/monthly_sales_model.dart';
import 'package:prototype/util/get_controllers/monthly_sale_controller.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/statistics/monthly_sales_bar.dart';
class SalesComparisonScreen extends StatefulWidget {
  const SalesComparisonScreen({super.key});

  @override
  SalesComparisonScreenState createState() => SalesComparisonScreenState();
}

class SalesComparisonScreenState extends State<SalesComparisonScreen> {
  int _selectedYear = int.parse(DateTime.now().year.toString());
  final monthlySaleController = Get.put(MonthlySaleController());
  Key futureBuilderKey = UniqueKey();

  void updateData(){
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    monthlySaleController.updateData.value = updateData;
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Actual vs Target'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MonthlySalesBarChart(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Year',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButton<int>(
                    value: _selectedYear,
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Theme.of(context).colorScheme.onSurface,
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
              const SizedBox(height: 30,),
              FutureBuilder(
                key: futureBuilderKey,
                future: monthlySaleController.getMonthlySales(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 26.0),
                          CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Loading...',
                            style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to load target sales data",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<MonthlySales> data = snapshot.data as List<MonthlySales>;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Text(
                            'Monthly Sales',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface
                            ),
                          ),
                          const SizedBox(height: 10),
                          DataTable(
                            columnSpacing: 20.0, // 调整列之间的间距
                            dataTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            columns: const [
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
                            rows: data.map((data) {
                              final difference = data.actualSales - data.targetSales;
                              final differenceText = difference.toStringAsFixed(2);
                              final differenceColor = difference < 0 ? Theme.of(context).colorScheme.error : null; // 若差值为负数则设置颜色为红色
                              if (data.year == _selectedYear){
                                return DataRow(cells: [
                                  DataCell(
                                    Text(
                                      _getMonthName(data.month), // Convert month number to month name
                                      style: TextStyle(
                                        fontSize: 14, // Adjust font size
                                        color: differenceColor, // Set color to red if necessary
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(data.actualSales.toStringAsFixed(2)), onTap: () => Get.to(() => EditSalesTarget(targetMonth: data, updateData: updateData,)),),
                                  DataCell(Text(data.targetSales.toStringAsFixed(2)), onTap: () => Get.to(() => EditSalesTarget(targetMonth: data, updateData: updateData,)),),
                                  DataCell(
                                    Text(
                                      differenceText,
                                      style: TextStyle(fontSize: 14, color: differenceColor), // Adjust font size and color
                                    ),
                                    onTap: () => Get.to(() => EditSalesTarget(targetMonth: data, updateData: updateData,)),
                                  ), // Display difference
                                ]);
                              }
                              else {
                                return DataRow(cells: [
                                  DataCell(
                                    Text(
                                      _getMonthName(data.month), // Convert month number to month name
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const DataCell(Text('-')),
                                  const DataCell(Text('-')),
                                  const DataCell(
                                    Text(
                                      '-',
                                      style: TextStyle(fontSize: 14), // Adjust font size and color
                                    ),
                                  ), // Display difference
                                ]);
                              }
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }
                  else {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to load sales target",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: 20),
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
  
  String _getMonthName(int monthNumber) {
    // Define a list of month names
    List<String> monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    // Ensure the monthNumber is within valid range (1 to 12)
    if (monthNumber >= 1 && monthNumber <= 12) {
      // Subtract 1 from monthNumber because month names are zero-indexed in DateTime
      return monthNames[monthNumber - 1];
    } 
    else {
      // Return a placeholder string if monthNumber is out of range
      return 'Unknown';
    }
  }
}
