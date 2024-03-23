import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/procurement/get_procurement.dart';
import 'package:prototype/util/request_util.dart';
final RequestUtil requestUtil = RequestUtil();

Future<List<String>> getCustomerList() async {
  final response = await requestUtil.getCustomersName();
  if (response.statusCode == 200){
    final List<dynamic> customers = jsonDecode(response.body);
    final List<String> customersList = customers.cast<String>();
    return customersList;
  }
  return [];
}
  
Future<List<String>> getOrderStatusList() async {
  return ['Pending', 'Completed'];
}

Future<List<String>> getCompletionStatusList() async {
  return ['To be Packaged', 'To be Shipped', 'To be Delivered', 'Delivered'];
}

Future<List<String>> getProductList() async {
  final response = await requestUtil.getProductsName();
  if (response.statusCode == 200){
    final List<dynamic> products = jsonDecode(response.body);
    final List<String> productsList = products.cast<String>();
    return productsList;
  }
  return [];
}

Future<List<String>> getUsersNameList() async {
  final response = await requestUtil.getUsersName();
  if (response.statusCode == 200){
    final List<dynamic> users = jsonDecode(response.body);
    final List<String> usersList = users.cast<String>();
    return usersList;
  }
  return [];
}

void updateProductID(String value, TextEditingController productIDController) async {
  final response = await requestUtil.getProductID(value);
  if (response.statusCode == 200){
    final dynamic productID = jsonDecode(response.body);
    productIDController.text = productID;
  }
}

void updateCustomerID(String value, TextEditingController customerIDController) async {
  final response = await requestUtil.getCustomerID(value);
  if (response.statusCode == 200){
    final dynamic customerID = jsonDecode(response.body);
    customerIDController.text = customerID;
  }
}

void updateUnitPrice(String value, TextEditingController unitPriceController, TextEditingController quantityController, TextEditingController totalPriceController) async {
  final response = await requestUtil.getProductSellingPrice(value);
  if (response.statusCode == 200) {
    final unitPrice = jsonDecode(response.body);
    unitPriceController.text = unitPrice.toStringAsFixed(2);
    updateTotalPrice(unitPriceController, quantityController, totalPriceController);
  }
}

void updateUserID(String value, TextEditingController userIDController) async {
  final response = await requestUtil.getUserID(value);
  if (response.statusCode == 200){
    final dynamic userID = jsonDecode(response.body);
    userIDController.text = userID;
  }
}