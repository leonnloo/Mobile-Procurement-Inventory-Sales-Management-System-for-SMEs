// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/util/get_controllers/inventory_controller.dart';

class InventoryStatusWidget extends StatelessWidget {
  const InventoryStatusWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: const Color.fromARGB(255, 252, 215, 252),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        // color: Theme.of(context).colorScheme.background,
        elevation: 4.0,
        // color: const Color.fromARGB(255, 11, 238, 181),
        margin: const EdgeInsets.all(16.0),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Inventory Overview',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 5,),
                InventoryCount(),
              ],
            ),
          ),
      ),
    );
  }
}

class InventoryCount extends StatelessWidget {
  InventoryCount({super.key,});

  int inStockCount = 0;
  int outOfStockCount = 0;
  int lowStockCount = 0;
  final inventoryController = Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: inventoryController.getInventories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            child: Center(
              child: CircularProgressIndicator(
                value: null, // null indicates an indeterminate progress which spins
                strokeWidth: 4.0, // Thickness of the circle line
                backgroundColor: Colors.transparent, // Color of the background circle
                color: Theme.of(context).colorScheme.onSurface, // Color of the progress indicator
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return SizedBox(
            height: 150.0,
            child: Center(
              child: Text('Unable to load', style: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.onSurface),),
            ),
          );
        } else {
          List<InventoryItem> inventorys = snapshot.data!;
          calculateStock(inventorys);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCol('$inStockCount', 'In Stock', context),
              _buildCol('$lowStockCount', 'Low Stock', context),
              _buildCol('$outOfStockCount', 'Out of Stock', context),
            ],
          );
        }
      }
    );
  }

  Widget _buildCol(String count, String label, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(count, style: TextStyle(fontSize: 24.0, color: Theme.of(context).colorScheme.onSurface),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.onSurface),),
            ],
          )
        ],
      ),
    );
  }
  
  void calculateStock(List<InventoryItem> inventorys) {
    for (var inventory in inventorys) {
      if (inventory.status == 'In Stock') {
        inStockCount++;
      } else if (inventory.status == 'Low Stock') {
        lowStockCount++;
      } else {
        outOfStockCount++;
      }
    }
  }
}
