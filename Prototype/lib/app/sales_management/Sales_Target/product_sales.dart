// import 'package:flutter/material.dart';
// import 'package:prototype/app/sales_management/product_monthly_sales.dart';
// import 'package:prototype/widgets/appbar/common_appbar.dart';

// class ProductSalesByMonth extends StatelessWidget {
//   const ProductSalesByMonth({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       appBar: CommonAppBar(currentTitle: 'Sales by Date'),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Add a GridView for buttons
//             SizedBox(height: 50.0),
//             Card(
//               elevation: 4.0,
//               margin: EdgeInsets.all(16.0),
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: ProductMonthlySalesLine1(),
//               ),
//             ),
// const SizedBox(height: 30,),
//             FutureBuilder(
//               future: _fetchSalesTargetData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const SizedBox(
//                     width: double.infinity,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 26.0),
//                         CircularProgressIndicator(
//                           backgroundColor: Colors.white,
//                           color: Colors.red,
//                         ),
//                         SizedBox(height: 16.0),
//                         Text(
//                           'Loading...',
//                           style: TextStyle(fontSize: 16.0, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Unable to load target sales data",
//                           style: TextStyle(color: Colors.black, fontSize: 20),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else if (snapshot.hasData) {
//                   List<SalesTargetData> data = snapshot.data as List<SalesTargetData>;
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       const Text(
//                         'Monthly Sales',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       DataTable(
//                         columnSpacing: 20.0, // 调整列之间的间距
//                         columns: const [
//                           DataColumn(
//                             label: Text(
//                               'Month',
//                               style: TextStyle(fontSize: 14), // 调整字体大小
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'Actual \nSales',
//                               style: TextStyle(fontSize: 14), // 调整字体大小
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'Target \nSales ',
//                               style: TextStyle(fontSize: 14), // 调整字体大小
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               'Difference',
//                               style: TextStyle(fontSize: 14), // 调整字体大小
//                             ),
//                           ), // 添加差值列
//                         ],
//                         rows: data.map((data) {
//                           final difference = data.actualSalesVolume - data.targetSalesVolume;
//                           final differenceText = difference.toString();
//                           final differenceColor = difference < 0 ? Colors.red : null; // 若差值为负数则设置颜色为红色
//                           if (data.year == _selectedYear){
//                             return DataRow(cells: [
//                               DataCell(
//                                 Text(
//                                   _getMonthName(data.month), // Convert month number to month name
//                                   style: TextStyle(
//                                     fontSize: 14, // Adjust font size
//                                     color: differenceColor, // Set color to red if necessary
//                                   ),
//                                 ),
//                               ),
//                               DataCell(Text(data.actualSalesVolume.toString())),
//                               DataCell(Text(data.targetSalesVolume.toString())),
//                               DataCell(
//                                 Text(
//                                   differenceText,
//                                   style: TextStyle(fontSize: 14, color: differenceColor), // Adjust font size and color
//                                 ),
//                               ), // Display difference
//                             ]);
//                           }
//                           else {
//                             return DataRow(cells: [
//                               DataCell(
//                                 Text(
//                                   _getMonthName(data.month), // Convert month number to month name
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                               const DataCell(Text('-')),
//                               const DataCell(Text('-')),
//                               const DataCell(
//                                 Text(
//                                   '-',
//                                   style: TextStyle(fontSize: 14), // Adjust font size and color
//                                 ),
//                               ), // Display difference
//                             ]);
//                           }
//                         }).toList(),
//                       ),
//                     ],
//                   );
//                 }
//                 else {
//                   return Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Unable to load sales target",
//                           style: TextStyle(color: Colors.black, fontSize: 20),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               }
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Future<List<SalesTargetData>> _fetchSalesTargetData() async {
//     final response = await managementUtil.getSalesTarget();
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       List<SalesTargetData> result = data.map((data) => SalesTargetData.fromJson(data)).toList();
//       return result;
//     }
//     else {
//       throw Exception('Failed to load sales target');
//     }
//   }
//   String _getMonthName(int monthNumber) {
//     // Define a list of month names
//     List<String> monthNames = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
    
//     // Ensure the monthNumber is within valid range (1 to 12)
//     if (monthNumber >= 1 && monthNumber <= 12) {
//       // Subtract 1 from monthNumber because month names are zero-indexed in DateTime
//       return monthNames[monthNumber - 1];
//     } 
//     else {
//       // Return a placeholder string if monthNumber is out of range
//       return 'Unknown';
//     }
//   }
// }
