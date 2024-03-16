import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';
import 'package:prototype/app/sales_management/product_monthly_sales.dart';

class SalesByDate extends StatelessWidget {
  const SalesByDate({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales by Date'), // Add title
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

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

          ],
        ),
      ),
    );
  }
}
