import 'dart:convert';

import 'package:get/get.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/util/request_util.dart';

class ProductController extends GetxController {
  static ProductController get find => Get.find();
  final RequestUtil requestUtil = RequestUtil();
  Rx<List<ProductItem>?> currentProductList = Rx<List<ProductItem>?>(null);
  Rx<ProductItem?> currentProductInfo = Rx<ProductItem?>(null);
  Rx<Function?> updateData = Rx<Function?>(null);
  Rx<Function?> updateEditData = Rx<Function?>(null);
  Rx<Function?> updateFilter = Rx<Function?>(null);

  Future<void> updateProductList() async {
    try {
      final product = await requestUtil.getProducts();
      if (product.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(product.body);
        List<ProductItem> productData = jsonData.map((data) => ProductItem.fromJson(data)).toList();
        currentProductList.value = productData;
      } else {
        throw Exception('Unable to fetch product data.');
      }
    } catch (error) {
      // print('Error in _fetchProductData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Future<List<ProductItem>> getProducts() async {
    if (currentProductList.value == null) {
      // Fetch data from the server if it's not already available
      await updateProductList();
    }
    return currentProductList.value ?? []; // Return an empty list if data is still null
  }

  void clearProducts(){
    currentProductList.value = null;
  }


  void updateProductInfo(ProductItem product) {
    currentProductInfo.value = product;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateData.value = null;
  }
}