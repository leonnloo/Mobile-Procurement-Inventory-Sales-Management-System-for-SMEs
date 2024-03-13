import 'package:flutter/material.dart';
import 'package:prototype/app/product/add_product.dart';
import 'package:prototype/models/productdata.dart';
import 'package:prototype/app/product/product_info.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  

  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  String? _selectedFilter;

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
              DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Unit Price')),
                  DataColumn(label: Text('Selling Price')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Weight')),
                  DataColumn(label: Text('Safety Quantity')),
                  DataColumn(label: Text('Markup')),
                  DataColumn(label: Text('Margin')),
                  DataColumn(label: Text('Status')),
                ],
                rows: _filterProducts().map((product) {
                  final double markup = calculateMarkup(
                    product.unitPrice.toDouble(),
                    product.sellingPrice.toDouble(),
                  );
                  final double margin = calculateMargin(
                    product.unitPrice.toDouble(),
                    product.sellingPrice.toDouble(),
                  );

                  return DataRow(cells: [
                    DataCell(
                      Text(
                        product.productID.toString(),
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        product.productName,
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        '\$${product.unitPrice.toString()}',
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        '\$${product.sellingPrice.toString()}',
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        product.quantity.toString(),
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        product.weight.toString(),
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        product.safetyQuantity.toString(),
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        markup.toStringAsFixed(2)+'%',
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        margin.toStringAsFixed(2)+'%',
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                    DataCell(
                      Text(
                        product.status,
                        style: TextStyle(
                          color: _getQuantityColor(
                            product.quantity,
                            product.safetyQuantity,
                          ),
                        ),
                      ),
                      onTap: () {
                        navigateToProductDetail(context, product);
                      },
                    ),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
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

  List<Product> _filterProducts() {
    if (_selectedFilter == null) {
      return products;
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
        case 'Weight':
          return products..sort((a, b) => a.weight.compareTo(b.weight));
        case 'Safety Quantity':
          return products..sort((a, b) => a.safetyQuantity.compareTo(b.safetyQuantity));
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
}
