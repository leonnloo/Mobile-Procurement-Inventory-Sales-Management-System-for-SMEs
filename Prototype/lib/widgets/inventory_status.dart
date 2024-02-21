import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryStatusWidget extends StatelessWidget {
  final int inStockCount;
  final int lowStockCount;
  final int outOfStockCount;

  const InventoryStatusWidget({super.key, 
    required this.inStockCount,
    required this.lowStockCount,
    required this.outOfStockCount,
  });
  
  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM d').format(DateTime.now());
    return Card(
      elevation: 4.0,
      color: Color.fromARGB(255, 11, 238, 181),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Inventory',
                      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10.0,),
                    Text(
                      currentDate,
                      style: const TextStyle(fontSize: 20.0,),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3.0,
                color: Colors.black,
              ),
              InventoryCount(inStockCount: inStockCount, outOfStockCount: outOfStockCount, lowStockCount: lowStockCount),
            ],
          ),
        ),
    );
  }
}

class InventoryCount extends StatelessWidget {
  const InventoryCount({
    super.key,
    required this.inStockCount,
    required this.outOfStockCount,
    required this.lowStockCount,
  });

  final int inStockCount;
  final int outOfStockCount;
  final int lowStockCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCol('$inStockCount', 'In Stock'),
        _buildCol('$lowStockCount', 'Low Stock'),
        _buildCol('$outOfStockCount', 'Out of Stock'),
      ],
    );
  }

  Widget _buildCol(String count, String label){
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(count, style: const TextStyle(fontSize: 15.0,),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontSize: 15.0,),),
            ],
          )
        ],
      ),
    );
  }
}
