import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/product/speed_dial_product.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/app/product/product_info.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';
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
  Map<String, List<ProductItem>> groupedData = {};
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
    groupedData['In Stock'] = [];
    groupedData['Low Stock'] = [];
    groupedData['Out of Stock'] = [];
    final productController = Get.put(ProductController());
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    productController.updateData.value = updateData;
    return DefaultTabController(
      length: groupedData.keys.length,
      initialIndex: 0,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
            TabBar(
              labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimaryContainer,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              labelPadding: const EdgeInsets.all(10),
              tabs: groupedData.keys.map((status) => Tab(text: status)).toList(),
            ),
            FutureBuilder(
              key: futureBuilderKey,
              future: productController.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
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
                  List<ProductItem> productItem = snapshot.data!;
                  for (var data in productItem) {
                    groupedData[data.status]?.add(data);
                  }
                  return Expanded(
                    child: TabBarView(
                      children: [
                        buildProductSection(context, groupedData['In Stock']!),
                        buildProductSection(context, groupedData['Low Stock']!),
                        buildProductSection(context, groupedData['Out of Stock']!),
                      ]
                    ),
                  );
                }
              }
            ),
          ],
        ),
        floatingActionButton: productSpeedDial(context)
      ),
    );
  }

  Widget buildProductSection(BuildContext context, List<ProductItem> productList) {
    productList = _fetchAndFilterProducts(productList);
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16.0,
          horizontalMargin: 16.0,
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
          rows: productList.map((ProductItem product) {
            return DataRow(
              cells: [
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
                  Text('\$${product.unitPrice.toStringAsFixed(2)}'),
                  onTap: () {
                    navigateToProductDetail(context, product);
                  }              
                ),
                DataCell(
                  Text('\$${product.sellingPrice.toStringAsFixed(2)}'),
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
              ],
            );
          }).toList(),
        )
      ),
    );
  }

  List<ProductItem> _fetchAndFilterProducts(List<ProductItem> products) {
    if (_selectedFilter == null) {
      return [];
    } else {
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
  }

  Key futureBuilderKey = UniqueKey();
  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}
