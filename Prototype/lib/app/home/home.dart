import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/add_customer.dart';
import 'package:prototype/app/customer/customer.dart';
import 'package:prototype/app/inventory/add_inventory.dart';
import 'package:prototype/app/inventory/inventory.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/app/product/add_product.dart';
import 'package:prototype/app/product/product.dart';
import 'package:prototype/app/sale_orders/add_order.dart';
import 'package:prototype/app/sales_management/management.dart';
import 'package:prototype/app/sale_orders/order.dart';
import 'package:prototype/app/settings/settings.dart';
import 'package:prototype/app/supplier/add_supplier.dart';
import 'package:prototype/app/supplier/supplier.dart';
import 'package:prototype/widgets/drawer/drawer_controller.dart';
import 'package:prototype/widgets/drawer/drawer_header.dart';
import 'package:prototype/widgets/drawer/drawer_list.dart';
import 'package:prototype/widgets/drawer/drawer_sections.dart';
import 'package:prototype/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final isDialOpen = ValueNotifier(false);
  Widget container = const HomeWidgets();
  String currentTitle = 'Dashboard';
  final controller = Get.put(CustomDrawerController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.currentPage.value == DrawerSections.dashboard) {
        container = const HomeWidgets();
        currentTitle = "Dashboard";
      } else if (controller.currentPage.value == DrawerSections.salesOrder) {
        container = const SalesOrderScreen();
        currentTitle = "Sales Order (Design how you see fit)";
      } else if (controller.currentPage.value == DrawerSections.salesManagement) {
        container = const SalesManagementScreen();
        currentTitle = "Sales Management (Design how you see fit)";
      } else if (controller.currentPage.value == DrawerSections.inventory) {
        container = const InventoryScreen();
        currentTitle = "Inventory (Design how you see fit)";
      } else if (controller.currentPage.value == DrawerSections.product) {
        container = const ProductManagementScreen();
        currentTitle = "Product";
      } else if (controller.currentPage.value == DrawerSections.procurement) {
        container = const ProcurementScreen();
        currentTitle = "Procurement (Design how you see fit)";
      } else if (controller.currentPage.value == DrawerSections.supplier) {
        container = const SupplierManagementScreen();
        currentTitle = "Supplier";
      } else if (controller.currentPage.value == DrawerSections.customer) {
        container = const CustomerManagementScreen();
        currentTitle = "Customer";
      } else if (controller.currentPage.value == DrawerSections.settings) {
        container = const SettingsScreen();
        currentTitle = "Settings";
      }
      return PopScope(
        canPop: false,
        onPopInvoked: (bool isDialOpen) async {
          if (isDialOpen) {
            isDialOpen = false;
            return;
          }
          Navigator.of(context).pop();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60.0,
            backgroundColor: Colors.red[400],
            title: Text(currentTitle),
          ),
          body: container,
        drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    const HeaderDrawer(),
                    drawerList(context),
                  ],
              ),
            ),
          ),
          floatingActionButton: homeSpeedDial(context),
        ),
      );
    });
  }

  Visibility homeSpeedDial(BuildContext context) {
    return Visibility(
      visible: controller.currentPage.value == DrawerSections.dashboard,
      child: SpeedDial(
        icon: Icons.add_outlined,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        spaceBetweenChildren: 10,
        overlayOpacity: 0.5,
        openCloseDial: isDialOpen,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.people),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            label: 'Add Customer',
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AddCustomerScreen(),
                  ),
                );               
              });
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.supervised_user_circle),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            label: 'Add Supplier',
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AddSupplierScreen(),
                  ),
                );               
              });
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_bag),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            label: 'Add Orders',
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AddOrderScreen(),
                  ),
                );               
              });
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_cart),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            label: 'Add Purchase',
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AddProcurementScreen(),
                  ),
                );               
              });
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            label: 'Add Product',
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                  ),
                );               
              });
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.inventory),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            label: 'Add Inventory',
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const AddInventoryScreen(),
                  ),
                );               
              });
            }
          ),
        ],
        
      ),
    );
  }
}
