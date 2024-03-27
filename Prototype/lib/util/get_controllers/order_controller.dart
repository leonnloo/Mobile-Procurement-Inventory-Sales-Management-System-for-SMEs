import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/request_util.dart';

class OrderController extends GetxController {
  static OrderController get find => Get.find();
  final RequestUtil requestUtil = RequestUtil();
  Rx<List<SalesOrder>?> currentOrderList = Rx<List<SalesOrder>?>(null);
  Rx<SalesOrder?> currentOrderInfo = Rx<SalesOrder?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);
  Rx<Function?> updateEditData = Rx<Function?>(null);

  Future<void> updateOrderList() async {
    try {
      final order = await requestUtil.getSaleOrders();
      if (order.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(order.body);
        List<SalesOrder> orderData = jsonData.map((data) => SalesOrder.fromJson(data)).toList();
        currentOrderList.value = orderData;
      } else {
        throw Exception('Unable to fetch order data.');
      }
    } catch (error) {
      // print('Error in _fetchOrderData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<SalesOrder>> getOrders() async {
    if (currentOrderList.value == null) {
      // Fetch data from the server if it's not already available
      await updateOrderList();
    }
    return currentOrderList.value ?? []; // Return an empty list if data is still null
  }

  void clearOrders(){
    currentOrderList.value = null;
  }


  void updateOrderInfo(SalesOrder order) {
    currentOrderInfo.value = order;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}