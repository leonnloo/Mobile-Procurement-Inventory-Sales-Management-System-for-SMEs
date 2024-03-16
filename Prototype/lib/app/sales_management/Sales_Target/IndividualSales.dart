import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/individual_sales.dart';


class IndividualSalesScreen extends StatelessWidget {
  const IndividualSalesScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Individual Employee Sales'), // Add title
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Add a GridView for buttons
            const SizedBox(height: 50.0),

            IndividualSales(),
          ],
        ),
      ),
    );
  }
}
