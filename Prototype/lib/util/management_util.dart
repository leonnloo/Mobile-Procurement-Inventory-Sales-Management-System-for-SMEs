import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prototype/util/user_controller.dart';

class ManagementUtil {
  late final String ipAddress;
  final int port = 8000;
  late final String endpoint;
  var token = '';
  final userLoggedInController = Get.put(UserLoggedInController());
  ManagementUtil() {
    // ipAddress = InternetAddress.loopbackIPv4.address;
    ipAddress = "10.0.2.2";
    endpoint = "http://$ipAddress:$port/";
    token = userLoggedInController.currentUser.value;
  }


  Future<http.Response> getSalesTarget() async {
    final response = await http.get(
      Uri.parse('${endpoint}sales-management/get_monthly_sales'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }
  Future<http.Response> updateMonthlyTargetSales(dynamic year, dynamic month, dynamic actualSales, dynamic targetSales) async {
    final response = await http.put(
      Uri.parse('${endpoint}sales-management/update_monthly_target_sales'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'year': year,
        'month': month,
        'actual_sales': actualSales,
        'target_sales': targetSales,
      })
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

  Future<http.Response> updateDispatch(String orderID, String completionStatus) async {
    final response = await http.put(
      Uri.parse('${endpoint}sales-management/update_dispatch/$orderID/$completionStatus'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }

  Future<http.Response> getRefunds() async {
    final response = await http.get(
      Uri.parse('${endpoint}sales-management/get_refunds'),
      headers: {
        'Authorization': 'Bearer $token'},
    );
    return response;
  }

  Future<http.Response> newRefund(dynamic orderID, dynamic orderStatus, dynamic refundDate, dynamic customerID, dynamic customerName, dynamic productID, dynamic productName, dynamic refundQuantity, dynamic orderPrice, dynamic refundAmount, dynamic reason) async {
    final response = await http.post(
      Uri.parse('${endpoint}sales-management/new_refund'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'refund_id': '',
        'order_id': orderID,
        'order_status': orderStatus,
        'refund_date': refundDate,
        'customer_id': customerID,
        'customer_name': customerName,
        'product_id': productID,
        'product_name': productName,
        'refund_quantity': refundQuantity,
        'order_price': orderPrice,
        'refund_amount': refundAmount,
        'reason': reason
      })
    );
    return response;
  }

  Future<http.Response> deleteRefund(String refundID) async {
    final response = await http.delete(
      Uri.parse('${endpoint}sales-management/delete_refund/$refundID'),
      headers: {
        'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }

}