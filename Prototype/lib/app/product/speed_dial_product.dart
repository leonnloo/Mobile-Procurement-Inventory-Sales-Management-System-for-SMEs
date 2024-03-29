import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:prototype/app/product/add_product.dart';
import 'package:prototype/app/product/stock_inout_prod.dart';

Widget productSpeedDial(BuildContext context) {
    return SpeedDial(
      icon: Icons.add_outlined,
      activeIcon: Icons.close_outlined,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      spaceBetweenChildren: 10,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.new_label),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: const CircleBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          label: 'Add New Product',
          onTap: () {
            Get.to(() => const AddProductScreen());
          }
        ),
        SpeedDialChild(
          child: const Icon(Icons.inventory),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          shape: const CircleBorder(),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          label: 'Stock In/Out',
          onTap: () {
            Get.to(() => const StockInOutProduct());
          }
        ),
      ],
      
    );
  }