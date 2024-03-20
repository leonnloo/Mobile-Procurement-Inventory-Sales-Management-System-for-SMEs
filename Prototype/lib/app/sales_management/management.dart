import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/monthly_sales_bar.dart';
import 'package:prototype/app/sales_management/individual_sales.dart';
import 'package:prototype/app/sales_management/product_monthly_sales.dart';
import 'Claims_and_Refunds/customerClaimsRefunds.dart';
import 'Dispatch_and_Delivery/dispatch_delivery.dart';
import 'Sales_Target/sales_target_screen.dart';

class SalesManagementScreen extends StatelessWidget {
  const SalesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.030,),
            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the second page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SalesTargetScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text('Sales Target',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the third page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DispatchDeliveryScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Order Dispatch and Delivery',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the fourth page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerClaimsRefundsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: const Text('Customer Claims, Refunds', 
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.045,),
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
