import 'package:flutter/material.dart';
import 'package:prototype/app/home/inventorystatus.dart';
import 'package:prototype/app/home/productsales.dart';
import 'package:prototype/app/inventory/inventorydata.dart';
import 'package:prototype/app/sales/management.dart';
import 'package:prototype/app/sales/monthlysalesbar.dart';
import 'package:prototype/app/sales/salesorders/addorder.dart';


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
                    MaterialPageRoute(builder: (context) => SalesManagementScreen()),
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
                    MaterialPageRoute(builder: (context) => SalesManagementScreen()),
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