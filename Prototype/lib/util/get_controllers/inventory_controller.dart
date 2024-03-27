import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/inventory_model.dart';
import 'package:prototype/util/request_util.dart';

class InventoryController extends GetxController {
  static InventoryController get find => Get.find();
  final RequestUtil requestUtil = RequestUtil();
  Rx<List<InventoryItem>?> currentInventoryList = Rx<List<InventoryItem>?>(null);
  Rx<InventoryItem?> currentInventoryInfo = Rx<InventoryItem?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);
  Rx<Function?> updateEditData = Rx<Function?>(null);

  Future<void> updateInventoryList() async {
    try {
      final inventory = await requestUtil.getInventories();
      if (inventory.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(inventory.body);
        List<InventoryItem> inventoryData = jsonData.map((data) => InventoryItem.fromJson(data)).toList();
        currentInventoryList.value = inventoryData;
      } else {
        throw Exception('Unable to fetch inventory data.');
      }
    } catch (error) {
      // print('Error in _fetchInventoryData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<InventoryItem>> getInventories() async {
    if (currentInventoryList.value == null) {
      // Fetch data from the server if it's not already available
      await updateInventoryList();
    }
    return currentInventoryList.value ?? []; // Return an empty list if data is still null
  }

  void clearInventories(){
    currentInventoryList.value = null;
  }


  void updateInventoryInfo(InventoryItem inventory) {
    currentInventoryInfo.value = inventory;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}