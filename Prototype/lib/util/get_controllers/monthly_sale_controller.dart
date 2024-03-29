import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/monthly_sales_model.dart';
import 'package:prototype/util/management_util.dart';

class MonthlySaleController extends GetxController {
  static MonthlySaleController get find => Get.find();
  final ManagementUtil managementUtil = ManagementUtil();
  Rx<List<MonthlySales>?> currentMonthlySaleList = Rx<List<MonthlySales>?>(null);
  Rx<MonthlySales?> currentMonthlySaleInfo = Rx<MonthlySales?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);

  Future<void> updateMonthlySaleList() async {
    try {
      var monthlySale = await managementUtil.getMonthlySales();
      if (monthlySale.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(monthlySale.body);
        List<MonthlySales> monthlySaleData = jsonData.map((data) => MonthlySales.fromJson(data)).toList();
        currentMonthlySaleList.value = monthlySaleData;
      } else {
        throw Exception('Unable to fetch monthly sale data.');
      }
    } catch (error) {
      // print('Error in _fetchMonthlySaleData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<MonthlySales>> getMonthlySales() async {
    if (currentMonthlySaleList.value == null) {
      await updateMonthlySaleList();
    }
    return currentMonthlySaleList.value ?? []; // Return an empty list if data is still null
  }

  void clearMonthlySales(){
    currentMonthlySaleList.value = null;
  }


  void updateMonthlySaleInfo(MonthlySales monthlySale) {
    currentMonthlySaleInfo.value = monthlySale;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}