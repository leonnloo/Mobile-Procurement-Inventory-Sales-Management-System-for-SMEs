import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/product/speed_dial_product.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/app/product/product_info.dart';
import 'package:prototype/util/request_util.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  ProductManagementScreenState createState() =>
      ProductManagementScreenState();
}

class ProductManagementScreenState extends State<ProductManagementScreen> {
  String? _selectedFilter;
  final RequestUtil requestUtil = RequestUtil();
  Color _getQuantityColor(int quantity, int safetyQuantity) {
    return quantity < safetyQuantity ? Colors.red : Colors.black;
  }

  double calculateMarkup(double costPrice, double sellingPrice) {
    return ((sellingPrice - costPrice) / costPrice) * 100;
  }

  double calculateMargin(double costPrice, double sellingPrice) {
    return ((sellingPrice - costPrice) / sellingPrice) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                width: 1100,
                child: Row(
                  children: [
                    const Text('Filter Products: '),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() {
                          _selectedFilter = value;
                        });
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'ID',
                          child: Text('ID'),
                        ),
                        const PopupMenuItem(
                          value: 'Product',
                          child: Text('Product'),
                        ),
                        const PopupMenuItem(
                          value: 'Unit Price',
                          child: Text('Unit Price'),
                        ),
                        const PopupMenuItem(
                          value: 'Selling Price',
                          child: Text('Selling Price'),
                        ),
                        const PopupMenuItem(
                          value: 'Quantity',
                          child: Text('Quantity'),
                        ),
                        const PopupMenuItem(
                          value: 'Weight',
                          child: Text('Weight'),
                        ),
                        const PopupMenuItem(
                          value: 'Safety Quantity',
                          child: Text('Safety Quantity'),
                        ),
                        const PopupMenuItem(
                          value: 'Markup',
                          child: Text('Markup'),
                        ),
                        const PopupMenuItem(
                          value: 'Margin',
                          child: Text('Margin'),
                        ),
                        const PopupMenuItem(
                          value: 'Status',
                          child: Text('Status'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              FutureBuilder(
                future: _fetchAndFilterProducts(),
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
                                  Text(
                                    product.quantity.toString(),
                                    style: TextStyle(
                                    color: _getQuantityColor(
                                      product.quantity,
                                      product.criticalLvl,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    navigateToProductDetail(context, product);
                                  }              
                                ),
                                DataCell(
                                  Text(product.margin),
                                  onTap: () {
                                    navigateToProductDetail(context, product);
                                  }              
                                ),
                                DataCell(
                                  Text(product.markup),
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
            ],
          ),
        ),
      ),
      floatingActionButton: productSpeedDial(context)
    );
  }


  Future<List<ProductItem>> _fetchAndFilterProducts() async {
    if (_selectedFilter == null) {
      return [];
    } else {
      final response = await requestUtil.getInventories();
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        
        List<ProductItem> products = jsonData.map((data) => ProductItem.fromJson(data)).toList();
        switch (_selectedFilter) {
          case 'ID':
            return products..sort((a, b) => a.productID.compareTo(b.productID));
          case 'Product':
            return products..sort((a, b) => a.productName.compareTo(b.productName));
          case 'Unit Price':
            return products..sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
          case 'Selling Price':
            return products..sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
          case 'Quantity':
            return products..sort((a, b) => a.quantity.compareTo(b.quantity));
          case 'Critical Level':
            return products..sort((a, b) => a.criticalLvl.compareTo(b.criticalLvl));
          case 'Markup':
            return products..sort((a, b) => calculateMarkup(a.unitPrice.toDouble(), a.sellingPrice).compareTo(calculateMarkup(b.unitPrice.toDouble(), b.sellingPrice)));
          case 'Margin':
            return products..sort((a, b) => calculateMargin(a.unitPrice.toDouble(), a.sellingPrice).compareTo(calculateMargin(b.unitPrice.toDouble(), b.sellingPrice)));
          case 'Status':
            return products..sort((a, b) => a.status.compareTo(b.status));
          default:
            return products;
        }
      }
      else{
        return [];
      }
    }
  }
}
