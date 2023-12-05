import 'package:flutter/material.dart';
import 'package:prototype/app/customer/customer.dart';
import 'package:prototype/app/home/inventorystatus.dart';
import 'package:prototype/app/home/productsales.dart';
import 'package:prototype/app/inventory/inventory.dart';
import 'package:prototype/app/inventory/inventorydata.dart';
import 'package:prototype/app/login.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/app/product/product.dart';
import 'package:prototype/app/sales/monthlysalesbar.dart';
import 'package:prototype/app/sales/management.dart';
import 'package:prototype/app/sales/salesorders/addorder.dart';
import 'package:prototype/app/supplier/supplier.dart';
import 'package:prototype/app/userprofile.dart';


class HomeScreen extends StatefulWidget {
  final int initialIndex;
  HomeScreen({this.initialIndex = 3});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 3;
  final List<Widget> _screens = [
    SalesManagementScreen(),
    ProcurementScreen(),
    ProductManagementScreen(),
    TotalProfitsScreen(),
    InventoryScreen(),
    SupplierManagementScreen(),
    CustomerManagementScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GRP Team-14'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => UserProfileScreen())
                );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
      ),
    );
  }
}



class TotalProfitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add logic to calculate total profits
    double totalProfits = 50000.00; // Replace your actual calculation
    // Calculate counts based on inventory status
    int inStockCount = inventoryItems
        .where((item) => item.status == 'In Stock')
        .length;

    int lowStockCount = inventoryItems
        .where((item) => item.status == 'Low Stock')
        .length;

    int outOfStockCount = inventoryItems
        .where((item) => item.status == 'Out of Stock')
        .length;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(26.0),
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: 0)),
                  );
                },
                child: Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column( // Wrap the Text widgets in a Column
                      children: [
                        const Text(
                          'Total Sales',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$$totalProfits',
                          style: TextStyle(fontSize: 32, color: Colors.green),
                        ),
                        SizedBox(height: 25),
                        InventoryPie(),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: 0)),
                  );
                },
                child: const Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SalesBarChart(),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  InventoryStatusWidget(
                    inStockCount: inStockCount, 
                    lowStockCount: lowStockCount,
                    outOfStockCount: outOfStockCount,
                  ),
                  Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddOrderScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Add Order",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.add),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      )
    );
  }
}

