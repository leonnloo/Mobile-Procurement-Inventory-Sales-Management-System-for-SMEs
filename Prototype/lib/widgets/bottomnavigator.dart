import 'package:flutter/material.dart';
import 'package:prototype/app/customer/customer.dart';
import 'package:prototype/app/home/home.dart';
import 'package:prototype/app/inventory/inventory.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/app/product/product.dart';
import 'package:prototype/app/sales/management.dart';
import 'package:prototype/app/supplier/supplier.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 3;
  final List<Widget> _screens = [
    SalesManagementScreen(),
    ProcurementScreen(),
    ProductManagementScreen(),
    HomeScreen(),
    InventoryScreen(),
    SupplierManagementScreen(),
    CustomerManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return 
      BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _screens[index]),
          );
        },
        backgroundColor: Color.fromARGB(255, 255, 16, 16),
        selectedItemColor: Color.fromARGB(255, 255, 0, 0),
        unselectedItemColor: Color.fromARGB(255, 6, 3, 3),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Procurement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Supplier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customer',
          ),
        ],
      );
  }
}
