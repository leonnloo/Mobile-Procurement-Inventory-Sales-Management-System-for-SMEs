import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:prototype/app/procurement/add_procurement.dart';
import 'package:prototype/app/procurement/monthly_purchases_statistic.dart';
import 'package:prototype/app/procurement/procurement_info.dart';
import 'package:prototype/app/procurement/weekly_purchases_statistic.dart';
import 'package:prototype/models/procurementdata.dart';
import 'package:prototype/app/procurement/procurement_filter_system.dart';
import 'package:prototype/widgets/home/home_search.dart';

class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});

  @override
  ProcurementScreenState createState() => ProcurementScreenState();
}

class ProcurementScreenState extends State<ProcurementScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: ListView(
            children:  <Widget>[
              //filter system
               SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const FilterSystem());
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
            
              const Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: WeeklyPurchasesBarChart(),
                ),
              ),
              const Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: MonthlyPurchaseChart(),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Past'),
                  Tab(text: 'Present'),
                ],
              ),
              const SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    ProcurementTab(category: 'Past'),
                    ProcurementTab(category: 'Present'),
                  ],
                ),
              ),
            ],
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
        ),
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
        child: DataTable(
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
