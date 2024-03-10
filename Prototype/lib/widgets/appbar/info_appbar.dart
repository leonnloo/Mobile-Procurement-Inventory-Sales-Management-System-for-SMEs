import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/edit_customer.dart';
import 'package:prototype/app/inventory/edit_inventory.dart';
import 'package:prototype/app/procurement/edit_procurement.dart';
import 'package:prototype/app/product/edit_product.dart';
import 'package:prototype/app/supplier/edit_supplier.dart';
import 'package:prototype/models/edit_type.dart';

class InfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  // InfoAppBar({super.key, required this.currentTitle, required this.currentData});

  final String currentTitle;
  final dynamic currentData;
  final bool isNoti;
  final EditType editType;

  const InfoAppBar({super.key, required this.currentTitle, required this.currentData, required this.editType})
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
                    Get.to(() => EditCustomer(customerData: currentData));
                  } else if (editType == EditType.supplier) {
                    Get.to(() => EditSupplier(supplierData: currentData));
                  } else if (editType == EditType.procurement) {
                    Get.to(() => EditProcurement(procurementData: currentData));
                  } else if (editType == EditType.product) {
                    Get.to(() => EditProduct(productData: currentData));
                  } else if (editType == EditType.inventory) {
                    Get.to(() => EditInventory(inventoryData: currentData));
                  }
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 30.0,
                ),
              ),
            ],
      backgroundColor: Colors.red[400],
      title: Text(currentTitle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
