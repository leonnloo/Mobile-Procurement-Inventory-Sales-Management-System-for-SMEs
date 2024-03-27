import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/product_sales.dart';
import 'package:prototype/widgets/statistics/monthly_sales_bar.dart';
import 'package:prototype/widgets/statistics/product_sales_pie.dart';
import 'package:prototype/widgets/icon_button.dart';
import 'Claims_and_Refunds/customer_claims_refunds.dart';
import 'Dispatch_and_Delivery/dispatch_delivery.dart';
import 'Sales_Target/sales_target_screen.dart';

class SalesManagementScreen extends StatelessWidget {
  const SalesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height * 0.030,),
                    buildButtonWithIcon(
                      onPressed: () {
                        // 导航到个人员工销售页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SalesTargetScreen() ),
                        );
                      },
                      icon: Icons.trending_up_rounded,
                      label: 'Sales Target',
                      context: context
                    ),
                    const SizedBox(height: 20.0),
                    buildButtonWithIcon(
                      onPressed: () {
                        // 导航到个人员工销售页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DispatchDeliveryScreen() ),
                        );
                      },
                      icon: Icons.local_shipping,
                      label: 'Order Dispatch and Delivery',
                      context: context
                    ),
                    const SizedBox(height: 20.0),
                    buildButtonWithIcon(
                      onPressed: () {
                        // 导航到按日期销售页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductSalesByMonth() ),
                        );
                      },
                      icon: Icons.sell_outlined,
                      label: 'Product Sales by Month',
                      context: context
                    ),
                    const SizedBox(height: 20.0),
                    buildButtonWithIcon(
                      onPressed: () {
                        // 导航到个人员工销售页面
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CustomerClaimsRefundsScreen() ),
                        );
                      },
                      icon: Icons.replay,
                      label: 'Customer Claims and Refunds',
                      context: context
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
