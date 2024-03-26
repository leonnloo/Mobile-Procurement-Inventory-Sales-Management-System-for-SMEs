import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/edit_customer.dart';
import 'package:prototype/app/inventory/edit_inventory.dart';
import 'package:prototype/app/procurement/edit_procurement.dart';
import 'package:prototype/app/product/edit_product.dart';
import 'package:prototype/app/sale_orders/edit_order.dart';
import 'package:prototype/app/supplier/edit_supplier.dart';
import 'package:prototype/models/edit_type.dart';

class InfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  // InfoAppBar({super.key, required this.currentTitle, required this.currentData});

  final String currentTitle;
  final dynamic currentData;
  final bool isNoti;
  final EditType editType;
  final Function? updateData;

  const InfoAppBar({super.key, required this.currentTitle, required this.currentData, required this.editType, this.updateData})
      : isNoti = currentTitle == 'Notifications';
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60.0,
      actions: isNoti
          ? []  // Empty list when isNoti is true, indicating no actions
          : [
              IconButton(
                onPressed: () {
                  if (editType == EditType.customer) {
                    Get.to(() => EditCustomer(customerData: currentData, updateData: updateData));
                  } else if (editType == EditType.supplier) {
                    Get.to(() => EditSupplier(supplierData: currentData, updateData: updateData!));
                  } else if (editType == EditType.procurement) {
                    Get.to(() => EditProcurement(procurementData: currentData, updateData: updateData!));
                  } else if (editType == EditType.product) {
                    Get.to(() => EditProduct(productData: currentData, updateData: updateData!));
                  } else if (editType == EditType.inventory) {
                    Get.to(() => EditInventory(inventoryData: currentData, updateData: updateData!));
                  } else if (editType == EditType.salesOrder) {
                    Get.to(() => EditOrder(orderData: currentData, updateData: updateData));
                  }
                },
                icon: Icon(
                  color: Theme.of(context).colorScheme.surface,
                  Icons.edit_rounded,
                  size: 30.0,
                ),
              ),
            ],
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      title: Text(currentTitle, style: TextStyle(color: Theme.of(context).colorScheme.surface),),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.surface, // Set the color of the back button
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
