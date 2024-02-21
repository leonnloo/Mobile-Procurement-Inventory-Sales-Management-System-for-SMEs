import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/sales_management/management.dart';
import 'package:prototype/models/productdata.dart';
import 'package:prototype/widgets/inventory_status.dart';
import 'package:prototype/widgets/product_sales_pie.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';


class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    // Add logic to calculate total profits
    double totalProfits = 50000.00; // Replace your actual calculation
    // Calculate counts based on inventory status
    int inStockCount = products
        .where((item) => item.status == 'In Stock')
        .length;

    int lowStockCount = products
        .where((item) => item.status == 'Low Stock')
        .length;

    int outOfStockCount = products
        .where((item) => item.status == 'Out of Stock')
        .length;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* ---------------FIRST WIDGET------------------*/
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                  },
                  child:
                    ProductStatusWidget(
                      inStockCount: inStockCount, 
                      lowStockCount: lowStockCount,
                      outOfStockCount: outOfStockCount,
                    ),
                ),
              ),
              /* ---------------SECOND WIDGET------------------*/
              GestureDetector(
                onTap: () {
                  Get.to(() => const SalesManagementScreen());
                },
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(16.0),
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
                          style: const TextStyle(fontSize: 32, color: Colors.green),
                        ),
                        const SizedBox(height: 25),
                        const ProductSalesPieChart(),
                      ],
                    ),
                  ),
                ),
              ),

              /* ---------------THIRD WIDGET------------------*/
              GestureDetector(
                onTap: () {
                },
                child: const Card(
                  
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: MonthlySalesBarChart(),
                  ),
                ),
              ),

            ],
          ),
      ),
    );
  }
}