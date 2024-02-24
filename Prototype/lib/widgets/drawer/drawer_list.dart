import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/widgets/drawer/drawer_controller.dart';
import 'package:prototype/widgets/drawer/drawer_sections.dart';

final controller = Get.put(CustomDrawerController());
Widget drawerList(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(
      top: 15,
    ),
    child: Obx(() {
      return Column(
      // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              controller.currentPage.value == DrawerSections.dashboard ? true : false, context),
          menuItem(2, "Sales Order", Icons.shopping_bag,
              controller.currentPage.value == DrawerSections.salesOrder ? true : false, context),
          menuItem(3, "Sales Management", Icons.business,
              controller.currentPage.value == DrawerSections.salesManagement ? true : false, context),
          const Divider(),
          menuItem(4, "Inventory", Icons.inventory,
              controller.currentPage.value == DrawerSections.inventory ? true : false, context),
          menuItem(5, "Product", Icons.category,
              controller.currentPage.value == DrawerSections.product ? true : false, context),
          menuItem(6, "Procurement", Icons.shopping_cart,
              controller.currentPage.value == DrawerSections.procurement ? true : false, context),
          const Divider(),
          menuItem(7, "Supplier", Icons.supervised_user_circle,
              controller.currentPage.value == DrawerSections.supplier ? true : false, context),
          menuItem(8, "Customer", Icons.people,
              controller.currentPage.value == DrawerSections.customer ? true : false, context),
          const Divider(),
          menuItem(9, "Settings", Icons.settings,
              controller.currentPage.value == DrawerSections.settings ? true : false, context),
        ],
      );
      }
    ),
  );
}

Widget menuItem(int id, String title, IconData icon, bool selected, BuildContext context) {
  return Material(
    color: selected ? Colors.grey[300] : Colors.transparent,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
          if (id == 1) {
            controller.changePage(DrawerSections.dashboard);
          } else if (id == 2) {
            controller.changePage(DrawerSections.salesOrder);
          } else if (id == 3) {
            controller.changePage(DrawerSections.salesManagement);
          } else if (id == 4) {
            controller.changePage(DrawerSections.inventory);
          } else if (id == 5) {
            controller.changePage(DrawerSections.product);
          } else if (id == 6) {
            controller.changePage(DrawerSections.procurement);
          } else if (id == 7) {
            controller.changePage(DrawerSections.supplier);
          } else if (id == 8) {
            controller.changePage(DrawerSections.customer);
          } else if (id == 9) {
            controller.changePage(DrawerSections.settings);
          }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}