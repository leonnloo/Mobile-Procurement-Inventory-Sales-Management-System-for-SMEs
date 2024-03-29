import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/procurement/procurement.dart';
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
    productController.updateFilter.value = updateFilter;
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
                child: Card(
                  child: GestureDetector(
                    onTap: () {
                      showSearch(context: context, delegate: ProductSearch(groupedData));
                    },
                    child: const TextField(
                      decoration: InputDecoration(
                        enabled: false,
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
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
  bool trackAscending = false;

  Widget buildProductSection(BuildContext context, List<ProductItem> productList) {
    productList = _fetchAndFilterProducts(productList);
    Function update = productController.updateFilter.value!;
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16.0,
          horizontalMargin: 16.0,
          columns: [
            DataColumn(
              label: Row(
                children: [
                  Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('ID');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Product', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Product');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Unit Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Unit Price');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Selling Price', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Selling Price');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Quantity', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Quantity');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Margin', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Margin');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Markup', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Markup');
              },
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Status', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                  Icon(
                    trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              onSort: (columnIndex, ascending) {
                ascending = trackAscending;
                trackAscending = !ascending;
                update('Status');
              },
            ),
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
          return products
            ..sort((a, b) {
              int idA = int.parse(a.productID.substring(2)); // Extract numeric part from productID
              int idB = int.parse(b.productID.substring(2));
              return trackAscending ? idA.compareTo(idB) : idB.compareTo(idA);
            });
        case 'Product':
          return products..sort((a, b) => trackAscending ? a.productName.toLowerCase().compareTo(b.productName.toLowerCase()) : b.productName.toLowerCase().compareTo(a.productName.toLowerCase()));
        case 'Unit Price':
          return products..sort((a, b) => trackAscending ? a.unitPrice.compareTo(b.unitPrice) : b.unitPrice.compareTo(a.unitPrice));
        case 'Selling Price':
          return products..sort((a, b) => trackAscending ? a.sellingPrice.compareTo(b.sellingPrice) : b.sellingPrice.compareTo(a.sellingPrice));
        case 'Quantity':
          return products..sort((a, b) => trackAscending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));
        case 'Critical Level':
          return products..sort((a, b) => trackAscending ? a.criticalLvl.compareTo(b.criticalLvl) : b.criticalLvl.compareTo(a.criticalLvl));
        case 'Markup':
          return products..sort((a, b) => trackAscending ? calculateMarkup(a.unitPrice.toDouble(), a.sellingPrice).compareTo(calculateMarkup(b.unitPrice.toDouble(), b.sellingPrice)) : calculateMarkup(b.unitPrice.toDouble(), b.sellingPrice).compareTo(calculateMarkup(a.unitPrice.toDouble(), a.sellingPrice)));
        case 'Margin':
          return products..sort((a, b) => trackAscending ? calculateMargin(a.unitPrice.toDouble(), a.sellingPrice).compareTo(calculateMargin(b.unitPrice.toDouble(), b.sellingPrice)) : calculateMargin(b.unitPrice.toDouble(), b.sellingPrice).compareTo(calculateMargin(a.unitPrice.toDouble(), a.sellingPrice)));
        case 'Status':
          return products..sort((a, b) => trackAscending ? a.status.compareTo(b.status) : b.status.compareTo(a.status));
        default:
          return products;
      }
    }
  }


  Key futureBuilderKey = UniqueKey();
  void updateData() async {
    if (mounted) {
      setState(() {
        futureBuilderKey = UniqueKey();
      });
    }
  }

  void updateFilter(String filter) async {
    if (mounted) {
      setState(() {
        _selectedFilter = filter;
      });
    }
  }
}


class ProductSearch extends SearchDelegate<String> {
  ProductSearch(this.groupedData);

  final Map<String, List<ProductItem>> groupedData;

  @override
  Widget buildSuggestions(BuildContext context) {
    // Flatten all ProductItem lists into a single list
    final allItems = groupedData.values.expand((list) => list).toList();

    // Filter the flattened list based on the query across all fields
    final List<ProductItem> suggestionList = query.isEmpty
      ? []
      : allItems.where((item) {
          // Adjusted to match the ProductItem properties
          final searchableString = '${item.productID} ${item.productName} ${item.quantity} '
              '${item.unitPrice} ${item.sellingPrice} ${item.status}'
              '${item.criticalLvl} ${item.margin} ${item.markup}'.toLowerCase();
          
          return searchableString.contains(query.toLowerCase());
        }).toList();


    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final ProductItem item = suggestionList[index];
        return ListTile(
          title: Text(item.productName),
          subtitle: Text('Price: ${item.sellingPrice} - Quantity: ${item.quantity}'),
          onTap: () {
            navigateToProductDetail(context, item);
          },
        );
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  String get searchFieldLabel => 'Enter Query';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        color: Theme.of(context).colorScheme.onPrimaryContainer, // Change this to the desired color
        toolbarHeight: 80
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),

      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),

      )
    );
  }
}