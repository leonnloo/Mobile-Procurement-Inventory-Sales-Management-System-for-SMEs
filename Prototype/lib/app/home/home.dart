import 'package:flutter/material.dart';
import 'package:prototype/app/customer/customer.dart';
import 'package:prototype/app/inventory/inventory.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/app/product/product.dart';
import 'package:prototype/app/sales_management/management.dart';
import 'package:prototype/app/sale_orders/order.dart';
import 'package:prototype/app/settings/settings.dart';
import 'package:prototype/app/supplier/supplier.dart';
import 'package:prototype/widgets/drawer_header.dart';
import 'package:prototype/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentPage = DrawerSections.dashboard;
  @override
  Widget build(BuildContext context) {
    var container;
    var currentTitle;
    if (currentPage == DrawerSections.dashboard) {
      container = HomeWidgets();
      currentTitle = "Dashboard";
    } else if (currentPage == DrawerSections.sales_order) {
      container = SalesOrderScreen();
      currentTitle = "Sales Order (Design how you see fit)";
    } else if (currentPage == DrawerSections.sales_management) {
      container = SalesManagementScreen();
      currentTitle = "Sales Management (Design how you see fit)";
    } else if (currentPage == DrawerSections.inventory) {
      container = InventoryScreen();
      currentTitle = "Inventory (Design how you see fit)";
    } else if (currentPage == DrawerSections.product) {
      container = ProductManagementScreen();
      currentTitle = "Product";
    } else if (currentPage == DrawerSections.procurement) {
      container = ProcurementScreen();
      currentTitle = "Procurement (Design how you see fit)";
    } else if (currentPage == DrawerSections.supplier) {
      container = SupplierManagementScreen();
      currentTitle = "Supplier";
    } else if (currentPage == DrawerSections.customer) {
      container = CustomerManagementScreen();
      currentTitle = "Customer";
    } else if (currentPage == DrawerSections.settings) {
      container = SettingsScreen();
      currentTitle = "Settings";
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.red[400],
        title: Text(currentTitle),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                HeaderDrawer(),
                MyDrawerList()
              ],
            ),
          ),
        ),
      ),
    );
  }

   Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Sales Order", Icons.shopping_bag,
              currentPage == DrawerSections.sales_order ? true : false),
          menuItem(3, "Sales Management", Icons.business,
              currentPage == DrawerSections.sales_management ? true : false),
          const Divider(),
          menuItem(4, "Inventory", Icons.inventory,
              currentPage == DrawerSections.inventory ? true : false),
          menuItem(5, "Product", Icons.category,
              currentPage == DrawerSections.product ? true : false),
          menuItem(6, "Procurement", Icons.shopping_cart,
              currentPage == DrawerSections.procurement ? true : false),
          const Divider(),
          menuItem(7, "Supplier", Icons.supervised_user_circle,
              currentPage == DrawerSections.supplier ? true : false),
          menuItem(8, "Customer", Icons.people,
              currentPage == DrawerSections.customer ? true : false),
          const Divider(),
          menuItem(9, "Settings", Icons.settings,
              currentPage == DrawerSections.settings ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.sales_order;
            } else if (id == 3) {
              currentPage = DrawerSections.sales_management;
            } else if (id == 4) {
              currentPage = DrawerSections.inventory;
            } else if (id == 5) {
              currentPage = DrawerSections.product;
            } else if (id == 6) {
              currentPage = DrawerSections.procurement;
            } else if (id == 7) {
              currentPage = DrawerSections.supplier;
            } else if (id == 8) {
              currentPage = DrawerSections.customer;
            } else if (id == 9) {
              currentPage = DrawerSections.settings;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
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
}

enum DrawerSections {
  dashboard,
  sales_order,
  sales_management,
  inventory,
  product,
  procurement,
  supplier,
  customer,
  settings
}
