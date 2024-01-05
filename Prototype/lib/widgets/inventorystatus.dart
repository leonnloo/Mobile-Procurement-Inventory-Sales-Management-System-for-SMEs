import 'package:flutter/material.dart';

class InventoryStatusWidget extends StatelessWidget {
  final int inStockCount;
  final int lowStockCount;
  final int outOfStockCount;

  InventoryStatusWidget({
    required this.inStockCount,
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory Status',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text('In Stock: $inStockCount items'),
              Text('Low Stock: $lowStockCount items'),
              Text('Out of Stock: $outOfStockCount items'),
            ],
          ),
        ),
    );
  }
}
