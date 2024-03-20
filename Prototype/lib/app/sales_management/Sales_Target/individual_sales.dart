import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/individual_sales.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';


class IndividualSalesScreen extends StatelessWidget {
  const IndividualSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Employee Monthly Sales'),
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
