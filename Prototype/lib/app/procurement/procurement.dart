import 'package:flutter/material.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/models/procurementdata.dart';
import 'package:prototype/app/procurement/procurement_info.dart';

class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});

  @override
  ProcurementScreenState createState() => ProcurementScreenState();
}

class ProcurementScreenState extends State<ProcurementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Past'),
                Tab(text: 'Present'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProcurementTab(category: 'Past'),
                  ProcurementTab(category: 'Present'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddProcurementScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProcurementTab extends StatelessWidget {
  final String category;

  const ProcurementTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<PurchasingOrder> orders = fetchDataForCategory(category);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: 
        DataTable(
          columnSpacing: 16.0, // Adjust the spacing between columns
          horizontalMargin: 16.0, // Adjust the horizontal margin
          columns: const [
            DataColumn(
              label: Text('Order No'),
            ),
            DataColumn(
              label: Text('Product ID'),
            ),
            DataColumn(
              label: Text('Supplier'),
            ),
            DataColumn(
              label: Text('Order Date'),
            ),
            DataColumn(
              label: Text('Delivery Date'),
            ),
            DataColumn(
              label: Text('Total Price'),
            ),
            DataColumn(
              label: Text('Quantity'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
          ],
          rows: orders.map((order) {
            return DataRow(
              cells: [
                DataCell(
                  Text(order.orderNumber.toString()),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.productID.toString()),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.supplierID.toString()),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.orderDate),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.deliveryDate),
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
                  Text(order.quantity.toString()),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
                DataCell(
                  Text(order.status),
                  onTap: () {
                    navigateToOrderDetail(context, order);
                  },
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}



  
void navigateToOrderDetail(BuildContext context, PurchasingOrder order) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)),
  );
}





