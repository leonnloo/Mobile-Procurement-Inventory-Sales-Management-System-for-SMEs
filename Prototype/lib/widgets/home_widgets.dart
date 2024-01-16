import 'package:flutter/material.dart';
import 'package:prototype/widgets/inventory_status.dart';
import 'package:prototype/widgets/product_sales_pie.dart';
import 'package:prototype/models/inventorydata.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';


class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});

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
                        const SizedBox(height: 25),
                        const ProductSalesPieChart(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                },
                child: const Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MonthlySalesBarChart(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                    },
                    child:
                      InventoryStatusWidget(
                        inStockCount: inStockCount, 
                        lowStockCount: lowStockCount,
                        outOfStockCount: outOfStockCount,
                      ),
                  ),
                  Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        // add order
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
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