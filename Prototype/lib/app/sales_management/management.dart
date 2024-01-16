import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';
import 'package:prototype/app/sales_management/individual_sales.dart';
import 'package:prototype/app/sale_orders/order.dart';
import 'package:prototype/app/sales_management/product_monthly_sales.dart';

class SalesManagementScreen extends StatelessWidget {
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
              child: Text('Sales Order (REMOVE THIS)'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Adjust the border radius as needed
                ),
                padding: EdgeInsets.all(8), // Adjust the padding as needed
                minimumSize: Size(100.0, 40.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
              },
              child: Text('Sales Target'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(8),
                minimumSize: Size(100.0, 40.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the third page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdPage()));
              },
              child: Text('Order Dispatch and Delivery (REMOVE THIS)'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(8),
                minimumSize: Size(100.0, 40.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the fourth page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => FourthPage()));
              },
              child: Text('Customer Claims, Refunds (REMOVE THIS)'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(8),
                minimumSize: Size(100.0, 40.0),
              ),
            ),
          ],
        ),
            ),

            // Add a GridView for buttons
            SizedBox(height: 50.0),
            // Add the charts below the buttons
            const Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),

                child: MonthlySalesBarChart(),
              ),
            ),
            const Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),

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
