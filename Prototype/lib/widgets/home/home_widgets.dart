import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/home/chatbot/chatbot.dart';
import 'package:prototype/widgets/drawer/drawer_controller.dart';
import 'package:prototype/models/drawer_sections.dart';
import 'package:prototype/widgets/inventory_overview.dart';
import 'package:prototype/widgets/product_overview.dart';
import 'package:prototype/widgets/product_sales_pie.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';


class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomDrawerController());
    // Add logic to calculate total profits
    double totalProfits = 50000.00; // Replace your actual calculation

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 34.0, 
                    fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline, 
                    letterSpacing: 2.0
                  ),
                ),
              ),
              /* ---------------FIRST WIDGET------------------*/

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const ChatBot());
                      },
                      child: const TextField(
                        decoration: InputDecoration(
                        enabled: false,
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                      ),
                    ),
                  ),
                ),
              ),

              /* ---------------SECOND WIDGET------------------*/

              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    controller.changePage(DrawerSections.inventory);
                  },
                  child:
                    // ProductStatusWidget(),
                    Container()
                ),
              ),

              /* ---------------THIRD WIDGET------------------*/

              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: InventoryOverview(),
                ),
              ),

              /* ---------------FOURTH WIDGET------------------*/

              GestureDetector(
                onTap: () {
                  controller.changePage(DrawerSections.salesManagement);
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

              /* ---------------FIFTH WIDGET------------------*/
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

