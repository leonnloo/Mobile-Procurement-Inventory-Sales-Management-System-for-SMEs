import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/util/request_util.dart';

class PurchaseController extends GetxController {
  static PurchaseController get find => Get.find();
  final RequestUtil requestUtil = RequestUtil();
  Rx<List<PurchasingOrder>?> currentPurchaseList = Rx<List<PurchasingOrder>?>(null);
  Rx<List<PurchasingOrder>?> currentPurchaseListPast = Rx<List<PurchasingOrder>?>(null);
  Rx<List<PurchasingOrder>?> currentPurchaseListPresent = Rx<List<PurchasingOrder>?>(null);
  Rx<PurchasingOrder?> currentPurchaseInfo = Rx<PurchasingOrder?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);
  Rx<Function?> updateEditData = Rx<Function?>(null);

  Future<void> updatePurchaseListCategory(String category) async {
    try {
      String newCategory;
      if (category == 'Past') {
        newCategory = 'Completed';
      } else {
        newCategory = 'Delivering';
      }

      final procurement = await requestUtil.getProcurementCategory(newCategory);
      if (procurement.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(procurement.body);
        List<PurchasingOrder> procurementData =
            jsonData.map((data) => PurchasingOrder.fromJson(data)).toList();
        if (category == 'Past') {
          currentPurchaseListPast.value = procurementData;
        } else if (category == 'Present') {
          currentPurchaseListPresent.value = procurementData;
        }
      } else {
        throw Exception('Unable to fetch procurement data.');
      }
    } catch (error) {
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<PurchasingOrder>> getPurchases(String category) async {
    if (currentPurchaseListPast.value == null) {
      await updatePurchaseListCategory('Past');
    } else if (currentPurchaseListPresent.value == null) {
      await updatePurchaseListCategory('Present');
    } else if (currentPurchaseList.value == null) {
      await updatePurchaseList();
    }
    if (category == 'Past') {
      return currentPurchaseListPast.value?? []; // Return an empty list if data is still null
    } else if (category == 'Present') {
      return currentPurchaseListPresent.value?? []; // Return an empty list if data is still null
    } else {
      return currentPurchaseList.value?? []; // Return an empty list if data is still null
    }
  }

  Future<void> updatePurchaseList() async {
    try {
      final purchase = await requestUtil.getProcurement();
    if (purchase.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(purchase.body);
        List<PurchasingOrder> purchaseData = jsonData.map((data) => PurchasingOrder.fromJson(data)).toList();
        currentPurchaseList.value = purchaseData;
      } else {
        throw Exception('Unable to fetch purchase data.');
      }
    } catch (error) {
      // print('Error in _fetchPurchaseData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  void clearPurchases(){
    currentPurchaseList.value = null;
    currentPurchaseListPast.value = null;
    currentPurchaseListPresent.value = null;
  }


  void updatePurchaseInfo(PurchasingOrder purchase) {
    currentPurchaseInfo.value = purchase;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}