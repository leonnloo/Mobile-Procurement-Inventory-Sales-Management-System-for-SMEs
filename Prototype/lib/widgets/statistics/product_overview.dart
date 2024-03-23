// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/util/request_util.dart';

class ProductStatusWidget extends StatelessWidget {
  const ProductStatusWidget({super.key});
  final int inStockCount = 0;

  final int lowStockCount = 0;

  final int outOfStockCount = 0;
  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM d').format(DateTime.now());
    return Card(
      elevation: 4.0,
      // color: const Color.fromARGB(255, 11, 238, 181),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Product Overview',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10.0,),
                    Text(
                      currentDate,
                      style: const TextStyle(fontSize: 16.0,),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3.0,
                color: Colors.black,
              ),
              InventoryCount(),
            ],
          ),
        ),
    );
  }
}

class InventoryCount extends StatelessWidget {
  InventoryCount({super.key,});

  int inStockCount = 0;
  int outOfStockCount = 0;
  int lowStockCount = 0;
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            child: Center(
              child: CircularProgressIndicator(
                value: null, // null indicates an indeterminate progress which spins
                strokeWidth: 4.0, // Thickness of the circle line
                backgroundColor: Colors.grey[200], // Color of the background circle
                color: Colors.red[400], // Color of the progress indicator
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const SizedBox(
            height: 150.0,
            child: Center(
              child: Text('Unable to load', style: TextStyle(fontSize: 14.0),),
            ),
          );
        } else {
          List<ProductItem> products = snapshot.data!;
          calculateStock(products);
          return Row(
            children: [
              _buildCol('$inStockCount', 'In Stock'),
              _buildCol('$lowStockCount', 'Low Stock'),
              _buildCol('$outOfStockCount', 'Out of Stock'),
            ],
          );
        }
      }
    );
  }

  Widget _buildCol(String count, String label){
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(count, style: const TextStyle(fontSize: 15.0,),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontSize: 15.0,),),
            ],
          )
        ],
      ),
    );
  }
  
  Future<List<ProductItem>> fetchProducts() async {
    final response = await requestUtil.getProducts();
    if (response.statusCode == 200){
      List<dynamic> data = jsonDecode(response.body);
      List<ProductItem> productItems = data.map((e) => ProductItem.fromJson(e)).toList();
      return productItems;
    }
    else {
      throw Exception('Failed to load products');
    }

  }
  
  void calculateStock(List<ProductItem> products) {
    for (var product in products) {
      if (product.status == 'In Stock') {
        inStockCount++;
      } else if (product.status == 'Low Stock') {
        lowStockCount++;
      } else {
        outOfStockCount++;
      }
    }
  }
}
