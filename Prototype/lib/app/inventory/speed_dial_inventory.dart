import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:prototype/app/inventory/add_inventory.dart';
import 'package:prototype/app/inventory/stock_inout_inv.dart';

Widget inventorySpeedDial(BuildContext context, Function updateData) {
    return SpeedDial(
      icon: Icons.add_outlined,
      activeIcon: Icons.close_outlined,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      spaceBetweenChildren: 10,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.new_label),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          label: 'Add New Item',
          onTap: () {
            Get.to(() => AddInventoryScreen(updateData: updateData));
          }
        ),
        SpeedDialChild(
          child: const Icon(Icons.inventory),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          label: 'Stock In/Out',
          onTap: () {
            Get.to(() => StockInOutInventory(updateData: updateData));;
          }
        ),
      ],
      
    );
  }