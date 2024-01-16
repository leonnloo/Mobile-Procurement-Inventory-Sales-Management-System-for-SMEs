import 'package:flutter/material.dart';
import 'package:prototype/app/product/add_product.dart';
import 'package:prototype/models/productdata.dart';
import 'package:prototype/app/product/product_info.dart';



class ProductManagementScreen extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                DataColumn(label: Text('Weight')),
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
                    Text('\$${product.unitPrice.toString()}'),
                    onTap: () {
                      navigateToProductDetail(context, product);
                    }              
                  ),
                  DataCell(
                    Text('\$${product.sellingPrice.toString()}'),
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
                    Text(product.weight.toString()),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


