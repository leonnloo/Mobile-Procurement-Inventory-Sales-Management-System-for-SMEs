import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/util/request_util.dart';

final RequestUtil requestUtil = RequestUtil();
Future<List<String>> getSupplierList() async {
  final response = await requestUtil.getSuppliersName();
  final List<dynamic> suppliers = jsonDecode(response.body);
  final List<String> suppliersList = suppliers.cast<String>();
  return suppliersList;
}

Future<List<String>> getProcurementTypeList() async {
  return ['Product', 'Inventory'];
}

Future<List<String>> getItemList(String type) async {
  if (type == 'Product') {
    final response = await requestUtil.getProductsName();
    final List<dynamic> items = jsonDecode(response.body);
    final List<String> itemsList = items.cast<String>();
    return itemsList;
  } else if (type == 'Inventory') {
    final response = await requestUtil.getInventoryName();
    final List<dynamic> items = jsonDecode(response.body);
    final List<String> itemsList = items.cast<String>();
    return itemsList;
  }
  return [];
}

void changeUnitPrice(String type, String item, TextEditingController unitPriceController, TextEditingController quantityController, TextEditingController totalPriceController) async {
  if (type == 'Product') {
    final response = await requestUtil.getProductUnitPrice(item);
    final items = jsonDecode(response.body);
    unitPriceController.text = items.toStringAsFixed(2);
    updateTotalPrice(unitPriceController, quantityController, totalPriceController);
  } else if (type == 'Inventory') {
    final response = await requestUtil.getInventoryUnitPrice(item);
    final items = jsonDecode(response.body);
    unitPriceController.text = items.toStringAsFixed(2);
    updateTotalPrice(unitPriceController, quantityController, totalPriceController);
  }
}

void updateTotalPrice(TextEditingController unitPriceController, TextEditingController quantityController, TextEditingController totalPriceController) {
  if (unitPriceController.text != '' && quantityController.text != '') {
    final totalPrice = double.parse(unitPriceController.text) * double.parse(quantityController.text);
    totalPriceController.text = totalPrice.toStringAsFixed(2);
  }
}

Future<List<String>> getProcurementStatusList() async {
  return ['Delivering', 'Completed'];
}

void updateItemID(String value, String type, TextEditingController itemIDController) async {
  if (type == 'Product') {
    final response = await requestUtil.getProductID(value);
    if (response.statusCode == 200) {
      final items = jsonDecode(response.body);
      itemIDController.text = items;
    }
  }
  else if (type == 'Inventory') {
    final response = await requestUtil.getInventoryID(value);
    if (response.statusCode == 200) {
      final items = jsonDecode(response.body);
      itemIDController.text = items;
    }
  }
}
