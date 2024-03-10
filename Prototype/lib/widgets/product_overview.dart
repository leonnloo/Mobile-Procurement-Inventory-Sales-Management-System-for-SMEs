// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:prototype/models/product_model.dart';

// class ProductStatusWidget extends StatelessWidget {
//   ProductStatusWidget({super.key});
  
//   final int inStockCount = products
//     .where((item) => item.status == 'In Stock')
//     .length;

//   final int lowStockCount = products
//     .where((item) => item.status == 'Low Stock')
//     .length;

//   final int outOfStockCount = products
//     .where((item) => item.status == 'Out of Stock')
//     .length;
//   @override
//   Widget build(BuildContext context) {
//     String currentDate = DateFormat('MMMM d').format(DateTime.now());
//     return Card(
//       elevation: 4.0,
//       color: const Color.fromARGB(255, 11, 238, 181),
//       margin: const EdgeInsets.all(16.0),
//       child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Product Overview',
//                       style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 10.0,),
//                     Text(
//                       currentDate,
//                       style: const TextStyle(fontSize: 16.0,),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(
//                 thickness: 3.0,
//                 color: Colors.black,
//               ),
//               InventoryCount(inStockCount: inStockCount, outOfStockCount: outOfStockCount, lowStockCount: lowStockCount),
//             ],
//           ),
//         ),
//     );
//   }
// }

// class InventoryCount extends StatelessWidget {
//   const InventoryCount({
//     super.key,
//     required this.inStockCount,
//     required this.outOfStockCount,
//     required this.lowStockCount,
//   });

//   final int inStockCount;
//   final int outOfStockCount;
//   final int lowStockCount;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _buildCol('$inStockCount', 'In Stock'),
//         _buildCol('$lowStockCount', 'Low Stock'),
//         _buildCol('$outOfStockCount', 'Out of Stock'),
//       ],
//     );
//   }

//   Widget _buildCol(String count, String label){
//     return Expanded(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(count, style: const TextStyle(fontSize: 15.0,),),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(label, style: const TextStyle(fontSize: 15.0,),),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
