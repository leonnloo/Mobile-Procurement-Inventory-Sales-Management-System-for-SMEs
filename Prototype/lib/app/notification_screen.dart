import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/login_content.dart';
import 'package:prototype/app/procurement/procurement.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/util/get_controllers/procurement_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Notifications'),
      body: Notifications()
    );
  }
}

class Notifications extends StatelessWidget {

  Notifications({super.key});
  final RequestUtil requestUtil = RequestUtil();
  final purchaseController = Get.put(PurchaseController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: purchaseController.getPurchases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white, 
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load procurement data",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            List<PurchasingOrder> orders = snapshot.data as List<PurchasingOrder>;
            DateTime now = DateTime.now();
            now = DateTime(now.year, now.month, now.day); // Reset to start of the current day
            DateTime weekLater = now.add(const Duration(days: 7));

            // Categorize orders
            List<PurchasingOrder> overdueOrders = orders.where((order) => order.status == 'Delivering' && DateTime.parse(order.deliveryDate).isBefore(now)).toList();
            List<PurchasingOrder> upcomingDeliveries = orders.where((order) => order.status == 'Delivering' && DateTime.parse(order.deliveryDate).compareTo(now) >= 0 && DateTime.parse(order.deliveryDate).isBefore(weekLater)).toList();

            // Combine and sort all relevant deliveries
            List<PurchasingOrder> combinedOrders = [...overdueOrders, ...upcomingDeliveries];
            combinedOrders.sort((a, b) => DateTime.parse(a.deliveryDate).compareTo(DateTime.parse(b.deliveryDate)));

            return ListView.builder(
              itemCount: combinedOrders.length,
              itemBuilder: (context, index) {
                PurchasingOrder order = combinedOrders[index];
                bool isOverdue = DateTime.parse(order.deliveryDate).isBefore(now);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Card(
                    color: isOverdue ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.onPrimary, // Highlight overdue orders
                    elevation: 5, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), 
                    ),
                    child: ListTile(
                      leading: isOverdue ? Icon(Icons.warning, color: Theme.of(context).colorScheme.error) : Icon(Icons.local_shipping, color: Theme.of(context).colorScheme.secondary),
                      title: Text(
                        '${order.itemName} (${order.itemID})',
                        style: TextStyle(
                          color: isOverdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface, 
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Quantity: ${order.quantity}\n'
                        'Delivery Date: ${order.deliveryDate}\n'
                        'Status: ${order.status.capitalizeFirst}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                        ),
                      ),
                      trailing: isOverdue ? Icon(Icons.error, color: Colors.red) : null, // Optional: different trailing icon for overdue
                    ),
                  ),
                );
              }
            );
          }
          return Container();
        });
  }
}

Future<List<PurchasingOrder>> _fetchProcurementData(String category) async {
  try {
    String newCategory;
    if (category == 'Past') {
      newCategory = 'Completed';
    } else {
      newCategory = 'Delivering';
    }

    final procurement = await requestUtil.getProcurementCategory(newCategory);
    if (procurement.statusCode == 200) {
      // Assuming the JSON response is a list of objects
      List<dynamic> jsonData = jsonDecode(procurement.body);

      // Map each dynamic object to PurchasingOrder
      List<PurchasingOrder> procurementData =
          jsonData.map((data) => PurchasingOrder.fromJson(data)).toList();
      return procurementData;
    } else {
      throw Exception('Unable to fetch procurement data.');
    }
  } catch (error) {
    // print('Error in _fetchCustomerData: $error');
    rethrow; // Rethrow the error to be caught by FutureBuilder
  }
}
