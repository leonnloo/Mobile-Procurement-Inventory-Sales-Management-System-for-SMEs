import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/home/chatbot/chatbot.dart';
import 'package:prototype/app/notification_screen.dart';
import 'package:prototype/widgets/drawer/drawer_controller.dart';
import 'package:prototype/models/drawer_sections.dart';
import 'package:prototype/widgets/statistics/product_sales_pie.dart';
import 'package:prototype/widgets/statistics/delivery_overview.dart';
import 'package:prototype/widgets/statistics/product_overview.dart';
import 'package:prototype/widgets/statistics/monthly_sales_bar.dart';


class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomDrawerController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.red[400],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Icon(
                          Icons.notes,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const NotificationScreen());
                        },
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  height: height * 0.25,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15.0, left: 15.0, top: 20.0),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38.0, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 2.0
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Text(
                          'Welcome back',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16.0, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 2.0
                          ),
                        ),
                      ),
                      /* ---------------FIRST WIDGET------------------*/
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
                          child: Card(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => const ChatBot());
                              },
                              child: const TextField(
                                decoration: InputDecoration(
                                enabled: false,
                                prefixIcon: Icon(Icons.search),
                                labelText: 'Ask me anything',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  width: width,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      /* ---------------SECOND WIDGET------------------*/
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            controller.changePage(DrawerSections.inventory);
                          },
                          child:
                            const ProductStatusWidget(),
                            // Container()
                        ),
                      ),
                  
                      /* ---------------THIRD WIDGET------------------*/
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            
                          },
                          child: DeliveryOverview(),
                        ),
                      ),
                            
                      /* ---------------FOURTH WIDGET------------------*/
                            
                      GestureDetector(
                        onTap: () {
                          controller.changePage(DrawerSections.salesManagement);
                        },
                        child: const ProductSalesPieChart(),
                      ),
                            
                      /* ---------------FIFTH WIDGET------------------*/
                      GestureDetector(
                        onTap: () {
                        },
                        child: Card(
                          
                          elevation: 4.0,
                          margin: const EdgeInsets.all(16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MonthlySalesBarChart(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

