import 'dart:convert';

import 'package:prototype/models/order_model.dart';
import 'package:prototype/models/refund_model.dart';
import 'package:prototype/util/management_util.dart';
import 'package:prototype/util/request_util.dart';

final RequestUtil requestUtil = RequestUtil();
final ManagementUtil managementUtil = ManagementUtil();

Future<List<SalesOrder>> getOrderList() async {
  final response = await requestUtil.getSaleOrders();
  if (response.statusCode == 200){
    List<dynamic> orders = jsonDecode(response.body);
    List<SalesOrder> salesOrders = orders.map((e) => SalesOrder.fromJson(e)).toList();
    return salesOrders;
  } else {
    throw Exception('Error while fetching sale orders');
  }
}


Future<List<Refunds>> fetchRefundData() async {
  final response = await managementUtil.getRefunds();
  if (response.statusCode == 200) {
    List<dynamic> orders = jsonDecode(response.body);
    List<Refunds> refunds = orders.map((e) => Refunds.fromJson(e)).toList();
    return refunds;
  } else {
    throw Exception('Error while fetching refunds');
  }
}