import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prototype/util/user_controller.dart';

class ManagementUtil {
  late final String ipAddress;
  final int port = 8000;
  late final String endpoint;
  var token = '';
  var currentUser = '';
  var currentUserID = '';
  final userLoggedInController = Get.put(UserLoggedInController());
  ManagementUtil() {
    // ipAddress = InternetAddress.loopbackIPv4.address;
    ipAddress = "10.0.2.2";
    endpoint = "http://$ipAddress:$port/";
    token = userLoggedInController.currentUser.value;
    currentUser = userLoggedInController.currentUser.value;
    currentUserID = userLoggedInController.currentUserID.value;
  }


  Future<http.Response> getSalesTarget() async {
    final response = await http.get(
      Uri.parse('${endpoint}sales-management/get_monthly_sales'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }

  Future<http.Response> getMonthlySales() async {
    final response = await http.get(
      Uri.parse('${endpoint}sales-management/get_monthly_sales'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }

  Future<http.Response> getProductMonthlySales() async {
    final response = await http.get(
      Uri.parse('${endpoint}sales-management/get_product_monthly_sales'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }
}