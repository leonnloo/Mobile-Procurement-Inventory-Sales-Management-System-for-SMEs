import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';
import 'package:prototype/app/sales_management/individual_sales.dart';
import 'package:prototype/app/sale_orders/order.dart';
import 'package:prototype/app/sales_management/product_monthly_sales.dart';

class SalesManagementScreen extends StatelessWidget {
  const SalesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 16.0,
          shrinkWrap: true,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the first page
                Navigator.push(context, MaterialPageRoute(builder: (context) => SalesOrderScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Adjust the border radius as needed
                ),
                padding: const EdgeInsets.all(8), // Adjust the padding as needed
                minimumSize: const Size(100.0, 40.0),
              ),
              child: const Text('Sales Order (REMOVE THIS)'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(100.0, 40.0),
              ),
              child: const Text('Sales Target'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the third page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdPage()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(100.0, 40.0),
              ),
              child: const Text('Order Dispatch and Delivery (REMOVE THIS)'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the fourth page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => FourthPage()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(100.0, 40.0),
              ),
              child: const Text('Customer Claims, Refunds (REMOVE THIS)'),
            ),
          ],
        ),
            ),

            // Add a GridView for buttons
            const SizedBox(height: 50.0),
            // Add the charts below the buttons
            const Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),

                child: MonthlySalesBarChart(),
              ),
            ),
            const Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),

                child: ProductMonthlySalesLine1(),
              ),
            ),
              
            IndividualSales(),
          ],
        ),
      ),
    );
  }
}
