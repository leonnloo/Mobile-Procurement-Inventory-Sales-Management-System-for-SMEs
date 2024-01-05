import 'package:flutter/material.dart';
import 'package:prototype/app/customer/customer.dart';
import 'package:prototype/app/home/home.dart';
import 'package:prototype/app/inventory/inventory.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/app/product/product.dart';
import 'package:prototype/app/sales/management.dart';
import 'package:prototype/app/supplier/supplier.dart';
import 'package:prototype/app/userprofile.dart';
import 'package:prototype/widgets/bottomnavigator.dart';

class ScreenManager extends StatefulWidget {


  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int _currentIndex = 3;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SalesManagementScreen(),
      ProcurementScreen(),
      ProductManagementScreen(),
      HomeScreen(onWidgetClick: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        ),
      InventoryScreen(),
      SupplierManagementScreen(),
      CustomerManagementScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GRP Team-14'), // company name
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _screens[_currentIndex])
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        }, currentIndex: _currentIndex,
      ),
    );
  }

}
