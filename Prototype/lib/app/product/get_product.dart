import 'package:flutter/material.dart';
import 'package:prototype/util/request_util.dart';
final RequestUtil requestUtil = RequestUtil();

Future<List<String>> getProductStatusList() async {
  return ['In Stock', 'Out of Stock'];
}

void calculateMarkupAndMargin(TextEditingController unitPriceController, TextEditingController sellingPriceController, TextEditingController marginController, TextEditingController markupController) {
  if (unitPriceController.text != '' && sellingPriceController.text!= ''){
    double unitPrice = double.tryParse(unitPriceController.text) ?? 0.0;
    double sellingPrice = double.tryParse(sellingPriceController.text) ?? 0.0;

    double markup = ((sellingPrice - unitPrice) / unitPrice) * 100;
    double margin = ((sellingPrice - unitPrice) / sellingPrice) * 100;

    markupController.text = markup.toStringAsFixed(2);
    marginController.text = margin.toStringAsFixed(2);
  }
}

void calculateSellingPrice(TextEditingController unitPriceController, TextEditingController sellingPriceController, TextEditingController markupController) {
  if (unitPriceController.text != '' && markupController.text!= '') {
    double unitPrice = double.tryParse(unitPriceController.text) ?? 0.0;
    double markup = double.tryParse(markupController.text) ?? 0.0;

    double sellingPrice = unitPrice + (unitPrice * markup / 100);

    sellingPriceController.text = sellingPrice.toStringAsFixed(2);
  }
}


