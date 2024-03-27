import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/add_customer.dart';
import 'package:prototype/app/customer/customer.dart';
import 'package:prototype/app/inventory/inventory.dart';
import 'package:prototype/app/inventory/stock_inout_inv.dart';
import 'package:prototype/app/notification_screen.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/app/product/product.dart';
import 'package:prototype/app/product/stock_inout_prod.dart';
import 'package:prototype/app/sale_orders/add_order.dart';
import 'package:prototype/app/sales_management/management.dart';
import 'package:prototype/app/sale_orders/order.dart';
import 'package:prototype/app/settings/settings.dart';
import 'package:prototype/app/supplier/add_supplier.dart';
import 'package:prototype/app/supplier/supplier.dart';
import 'package:prototype/widgets/drawer/drawer_controller.dart';
import 'package:prototype/widgets/drawer/drawer_header.dart';
import 'package:prototype/widgets/drawer/drawer_list.dart';
import 'package:prototype/models/drawer_sections.dart';
import 'package:prototype/widgets/home/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final isDialOpen = ValueNotifier(false);
  Widget container = HomeWidgets();
  String currentTitle = 'Dashboard';
  final controller = Get.put(CustomDrawerController());
  DateTime? currentBackPressTime;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.currentPage.value == DrawerSections.dashboard) {
        container = HomeWidgets();
        currentTitle = "Dashboard";
      } else if (controller.currentPage.value == DrawerSections.salesOrder) {
        container = const SalesOrderScreen();
        currentTitle = "Sales Order";
      } else if (controller.currentPage.value == DrawerSections.salesManagement) {
        container = const SalesManagementScreen();
        currentTitle = "Sales Management";
      } else if (controller.currentPage.value == DrawerSections.inventory) {
        container = const InventoryScreen();
        currentTitle = "Inventory";
      } else if (controller.currentPage.value == DrawerSections.product) {
        container = const ProductManagementScreen();
        currentTitle = "Product";
      } else if (controller.currentPage.value == DrawerSections.procurement) {
        container = const ProcurementScreen();
        currentTitle = "Procurement";
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
          // If the dial is open and the back button is pressed, close the dial.
          if (isDialOpen) {
            isDialOpen = false;
            return;
          }

          // If current page is not dashboard, press back button to go back to dashboard.
          if (controller.currentPage.value != DrawerSections.dashboard){
            controller.changePage(DrawerSections.dashboard);
            isDialOpen = false;
            return;
          } 

          // If the drawer is open, close it
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            _scaffoldKey.currentState?.openEndDrawer();
            return;
          }

          // Handle double press to exit
          DateTime now = DateTime.now();
          if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
            currentBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
              ),
            );
            return;
          } else {
            exit(0);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: controller.currentPage.value == DrawerSections.dashboard ? null : AppBar(
            toolbarHeight: 60.0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  color: Theme.of(context).colorScheme.surface,
                  Icons.notes, // Replace with the desired icon
                  size: 30.0,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(onPressed: () {Get.to(() => const NotificationScreen());}, icon: Icon(Icons.notifications, size: 30.0, color: Theme.of(context).colorScheme.surface),),
            ],
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            title: Text(controller.currentPage.value == DrawerSections.dashboard ? '' : currentTitle, style: TextStyle(color: Theme.of(context).colorScheme.surface),),
          ),
          body: container,
          drawer: Drawer(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
        activeIcon: Icons.close_outlined,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        spaceBetweenChildren: 10,
        overlayOpacity: 0.5,
        openCloseDial: isDialOpen,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.people),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            shape: const CircleBorder(),
            label: 'Add Customer',
            onTap: () {
              Get.to(() => const AddCustomerScreen());
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.supervised_user_circle),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            shape: const CircleBorder(),
            label: 'Add Supplier',
            onTap: () {
              Get.to(() => const AddSupplierScreen());
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_bag),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            shape: const CircleBorder(),
            label: 'Add Orders',
            onTap: () {
              Get.to(() => const AddOrderScreen());
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_cart),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            shape: const CircleBorder(),
            label: 'Add Purchase',
            onTap: () {
              Get.to(() => const AddProcurementScreen());
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            shape: const CircleBorder(),
            label: 'Stock In/Out Product',
            onTap: () {
              Get.to(() => const StockInOutProduct());
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.inventory),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            shape: const CircleBorder(),
            label: 'Stock In/Out Inventory',
            onTap: () {
              Get.to(() => const StockInOutInventory());
            }
          ),
        ],
        
      ),
    );
  }
}


