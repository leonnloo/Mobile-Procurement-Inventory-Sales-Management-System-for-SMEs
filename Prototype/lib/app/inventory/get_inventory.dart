import 'dart:convert';

import 'package:prototype/util/request_util.dart';

final RequestUtil requestUtil = RequestUtil();


Future<List<String>> getInventoryCategoryList() async {
  return ['Packing material', 'Raw material', 'Work-in-progress', 'Safety stock', 'Trading goods', 'Services'];
}

Future<List<String>> getInventoryItemList() async {
    final response = await requestUtil.getInventoryName();
    final List<dynamic> items = jsonDecode(response.body);
    final List<String> itemsList = items.cast<String>();
    return itemsList;
}
