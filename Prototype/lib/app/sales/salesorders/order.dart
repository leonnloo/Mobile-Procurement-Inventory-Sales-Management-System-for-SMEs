import "package:flutter/material.dart";
import 'package:prototype/app/sales/salesorders/addorder.dart';
import 'package:prototype/models/orderdata.dart';
import 'package:prototype/app/sales/salesorders/orderinfo.dart';


class SalesOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Order'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 150,
          ),
          child: DataTable(
            columnSpacing: 16.0,
            horizontalMargin: 16.0,
            columns: const [
              DataColumn(label: Text('Order No')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Customer ID')),
              DataColumn(label: Text('Product ID')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Total Price')),
              DataColumn(label: Text('Status')),
            ],
            rows: salesOrders.map((SalesOrder order) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(order.orderNo.toString()),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                  DataCell(
                    Text(order.date ?? 'N/A'),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                  DataCell(
                    Text(order.customerID.toString() ?? 'N/A'),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                  DataCell(
                    Text(order.productID.toString() ?? 'N/A'),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                  DataCell(
                    Text(order.quantity.toString()),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                  DataCell(
                    Text('\$${order.totalPrice.toString()}'),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                  DataCell(
                    Text(order.status ?? 'N/A'),
                    onTap: () {
                      navigateToOrderDetail(context, order);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddOrderScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
