import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/supplier_model.dart';
import 'package:prototype/util/request_util.dart';

class SupplierController extends GetxController {
  static SupplierController get find => Get.find();
  final RequestUtil requestUtil = RequestUtil();
  Rx<List<SupplierData>?> currentSupplierList = Rx<List<SupplierData>?>(null);
  Rx<SupplierData?> currentSupplierInfo = Rx<SupplierData?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);
  Rx<Function?> updateEditData = Rx<Function?>(null);

  Future<void> updateSupplierList() async {
    try {
      final customer = await requestUtil.getSuppliers();
      if (customer.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(customer.body);
        List<SupplierData> supplierData = jsonData.map((data) => SupplierData.fromJson(data)).toList();
        currentSupplierList.value = supplierData;
      } else {
        throw Exception('Unable to fetch supplier data.');
      }
    } catch (error) {
      // print('Error in _fetchSupplierData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<SupplierData>> getSuppliers() async {
    if (currentSupplierList.value == null) {
      // Fetch data from the server if it's not already available
      await updateSupplierList();
    }
    return currentSupplierList.value ?? []; // Return an empty list if data is still null
  }

  void clearSuppliers(){
    currentSupplierList.value = null;
  }


  void updateSupplierInfo(SupplierData supplier) {
    currentSupplierInfo.value = supplier;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}