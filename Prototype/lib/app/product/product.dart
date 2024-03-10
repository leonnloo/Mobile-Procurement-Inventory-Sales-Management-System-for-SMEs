import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/product/add_product.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/app/product/product_info.dart';
import 'package:prototype/util/request_util.dart';



class ProductManagementScreen extends StatelessWidget {
  ProductManagementScreen({super.key});
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchProductData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.red[400],
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(top: 20.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load products",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            List<ProductItem> products = snapshot.data as List<ProductItem>;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, 
              child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Unit Price')),
                      DataColumn(label: Text('Selling Price')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Margin')),
                      DataColumn(label: Text('Markup')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: products.map((product) {
                      return DataRow(cells: [
                        DataCell(
                          Text(product.productID.toString()),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }
                        ),
                        DataCell(
                          Text(product.productName),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }
                        ),
                        DataCell(
                          Text('\$${product.unitPrice.toStringAsFixed(2).toString()}'),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }              
                        ),
                        DataCell(
                          Text('\$${product.sellingPrice.toStringAsFixed(2).toString()}'),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }              
                        ),
                        DataCell(
                          Text(product.quantity.toString()),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }              
                        ),
                        DataCell(
                          Text('${product.margin.toString()}%'),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }              
                        ),
                        DataCell(
                          Text('${product.markup.toString()}%'),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }              
                        ),
                        DataCell(
                          Text(product.status),
                          onTap: () {
                            navigateToProductDetail(context, product);
                          }              
                        ),
                      ]);
                    }).toList(),
                  ),
                )
            );
          }
          else {
            return Container();
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<ProductItem>> _fetchProductData() async {
    try {
      final products = await requestUtil.getProducts();
      if (products.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(products.body);
        List<ProductItem> productData = jsonData.map((data) => ProductItem.fromJson(data)).toList();
        return productData;
      } else {
        throw Exception('Unable to fetch products data.');
      }
    } catch (error) {
      // print('Error in _fetchProductData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }
}


