import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype/app/authenticate/screens/login_content.dart';
import 'package:prototype/models/procurement_model.dart';
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
      body: Notifications(category: 'Present')
    );
  }
}

class Notifications extends StatelessWidget {
  final String category;

  Notifications({super.key, required this.category});
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchProcurementData(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white, 
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.red, 
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Unable to load procurement data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            List<PurchasingOrder> orders =
                snapshot.data as List<PurchasingOrder>;
            List<String> notifications = [];
            for (PurchasingOrder order in orders) {
              DateTime deliveryDate = DateTime.parse(order.deliveryDate);
              DateTime now = DateTime.now();
              if (deliveryDate.compareTo(now) <= 0) {
                String notification =
                    'Arrival of ${order.itemName} ${order.itemID} ---------- ${order.deliveryDate}';
                notifications.add(notification);
              }
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Card(
                    elevation: 5, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), 
                    ),
                    child: ListTile(
                      title: Text(
                        notifications[index],
                        style: const TextStyle(
                          color: Colors.black, 
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
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
