import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/util/request_util.dart';

class CustomerController extends GetxController {
  static CustomerController get find => Get.find();
  final RequestUtil requestUtil = RequestUtil();
  Rx<List<CustomerData>?> currentCustomerList = Rx<List<CustomerData>?>(null);
  Rx<CustomerData?> currentCustomerInfo = Rx<CustomerData?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);
  Rx<Function?> updateEditData = Rx<Function?>(null);
  Rx<Function?> updateFilter = Rx<Function?>(null);

  Future<void> updateCustomerList() async {
    try {
      final customer = await requestUtil.getCustomers();
      if (customer.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(customer.body);
        List<CustomerData> customerData = jsonData.map((data) => CustomerData.fromJson(data)).toList();
        currentCustomerList.value = customerData;
      } else {
        throw Exception('Unable to fetch customer data.');
      }
    } catch (error) {
      // print('Error in _fetchCustomerData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<CustomerData>> getCustomers() async {
    if (currentCustomerList.value == null) {
      // Fetch data from the server if it's not already available
      await updateCustomerList();
    }
    return currentCustomerList.value ?? []; // Return an empty list if data is still null
  }

  void clearCustomers(){
    currentCustomerList.value = null;
  }


  void updateCustomerInfo(CustomerData customer) {
    currentCustomerInfo.value = customer;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}