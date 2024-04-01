import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/home/chatbot/chatbot.dart';
import 'package:prototype/app/notification_screen.dart';
import 'package:prototype/app/sales_management/Dispatch_and_Delivery/dispatch_delivery.dart';
import 'package:prototype/util/get_controllers/user_controller.dart';
import 'package:prototype/widgets/drawer/drawer_controller.dart';
import 'package:prototype/models/drawer_sections.dart';
import 'package:prototype/widgets/statistics/inventory_overview.dart';
import 'package:prototype/widgets/statistics/order_overview.dart';
import 'package:prototype/widgets/statistics/product_sales_pie.dart';
import 'package:prototype/widgets/statistics/delivery_overview.dart';
import 'package:prototype/widgets/statistics/product_overview.dart';
import 'package:prototype/widgets/statistics/monthly_sales_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

  final controller = Get.put(CustomDrawerController());
class HomeWidgets extends StatelessWidget {
  HomeWidgets({super.key});
  final userController = Get.put(UserLoggedInController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                      child: Icon(
                        Icons.notes,
                        color: Theme.of(context).colorScheme.surface,
                        size: 32,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const NotificationScreen());
                      },
                      child: Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.surface,
                        size: 32,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(),
                height: isPortrait ? height * 0.28 : height * 0.6,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 20.0),
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 40, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1.0
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Text(
                        'Welcome back ${userController.currentUser.value}',
                        style: const TextStyle(
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
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 20,),
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
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: const BorderRadius.only(
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
                      child: buildCarousel(),
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
                        // controller.changePage(DrawerSections.salesManagement);
                      },
                      child: const ProductSalesPieChart(),
                    ),
                          
                    /* ---------------FIFTH WIDGET------------------*/
                    GestureDetector(
                      onTap: () {
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MonthlySalesBarChart(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCarousel() {
  return CarouselSlider(
    options: CarouselOptions(
      autoPlayInterval: const Duration(seconds: 5),
      autoPlay: true,
      height: 200, // Adjust the height as needed
      viewportFraction: 0.95,
      enlargeCenterPage: true,
      enableInfiniteScroll: true,
    ),
    items: [
      // Product Section
      GestureDetector(
        onTap: () {
          controller.changePage(DrawerSections.product);
        },
        child: const ProductStatusWidget(),
      ),
      // Inventory Section
      GestureDetector(
        onTap: () {
          controller.changePage(DrawerSections.inventory);
        },
        child: const InventoryStatusWidget(),
      ),
      GestureDetector(
        onTap: () {
          Get.to(() => const DispatchDeliveryScreen());
        },
        child: const OrderStatusWidget(),
      ),
    ],
  );
}

}

