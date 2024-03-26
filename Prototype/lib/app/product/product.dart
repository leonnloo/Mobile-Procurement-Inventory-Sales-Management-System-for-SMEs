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
  String? _selectedFilter = 'ID';
  final RequestUtil requestUtil = RequestUtil();
  Color _getQuantityColor(int quantity, int safetyQuantity) {
    return quantity < safetyQuantity ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface;
  }

  double calculateMarkup(double costPrice, double sellingPrice) {
    return ((sellingPrice - costPrice) / costPrice) * 100;
  }

  double calculateMargin(double costPrice, double sellingPrice) {
    return ((sellingPrice - costPrice) / sellingPrice) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
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
                      PopupMenuItem(
                        value: 'ID',
                        child: Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Product',
                        child: Text('Product', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Unit Price',
                        child: Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Selling Price',
                        child: Text('Selling Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Quantity',
                        child: Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Weight',
                        child: Text('Weight', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Safety Quantity',
                        child: Text('Safety Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Markup',
                        child: Text('Markup', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Margin',
                        child: Text('Margin', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                      PopupMenuItem(
                        value: 'Status',
                        child: Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          FutureBuilder(
            key: futureBuilderKey,
            future: _fetchAndFilterProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: size.height * 0.8,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 26.0),
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Loading...',
                        style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: size.height * 0.8,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Unable to load products",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData) {
                return Container(
                  width: double.infinity,
                  height: size.height * 0.8,
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No products available",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
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
                        columns: [
                          DataColumn(label: Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Product', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Selling Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Margin', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Markup', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                        ],
                        rows: products.map((product) {
                          return DataRow(cells: [
                            DataCell(
                              Text(product.productID.toString()),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
                              }
                            ),
                            DataCell(
                              Text(product.productName),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
                              }
                            ),
                            DataCell(
                              Text('\$${product.unitPrice.toStringAsFixed(2).toString()}'),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
                              }              
                            ),
                            DataCell(
                              Text('\$${product.sellingPrice.toStringAsFixed(2).toString()}'),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
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
                                navigateToProductDetail(context, product, updateData);
                              }              
                            ),
                            DataCell(
                              Text(product.margin),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
                              }              
                            ),
                            DataCell(
                              Text(product.markup),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
                              }              
                            ),
                            DataCell(
                              Text(product.status),
                              onTap: () {
                                navigateToProductDetail(context, product, updateData);
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
      floatingActionButton: productSpeedDial(context, updateData)
    );
  }


  Future<List<ProductItem>> _fetchAndFilterProducts() async {
    if (_selectedFilter == null) {
      return [];
    } else {
      final response = await requestUtil.getProducts();
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

  Key futureBuilderKey = UniqueKey();
  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}
