import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:prototype/models/monthly_sales_model.dart';
import 'package:prototype/util/get_controllers/monthly_sale_controller.dart';
import 'package:prototype/util/management_util.dart';

class MonthlySalesBarChart extends StatelessWidget {
  MonthlySalesBarChart({super.key});
  final ManagementUtil managementUtil = ManagementUtil();
  final monthlySaleController = Get.put(MonthlySaleController());
  @override
  Widget build(BuildContext context) {
    monthlySaleController.clearMonthlySales();
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                'Monthly Sales',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 230,
              child: FutureBuilder(
                future: monthlySaleController.getMonthlySales(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 26.0),
                          CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Loading...',
                            style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to load monthly sales",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No monthly sales available",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final monthlyList = snapshot.data!;
                    if (monthlyList.isNotEmpty) {
                      monthlyList.sort((a, b) {
                        // First, compare by year
                        int compareYear = a.year.compareTo(b.year);
                        if (compareYear != 0) {
                          // If the years are not equal, the comparison is decided by the year difference.
                          return compareYear;
                        } else {
                          // If the years are equal, compare by month
                          return a.month.compareTo(b.month);
                        }
                      });
          
                      return BarChart(
                        BarChartData(
                          barTouchData: barTouchData,
                          titlesData: _getTitlesData(monthlyList),
                          borderData: borderData,
                          barGroups: _getBarGroups(monthlyList),
                          gridData: const FlGridData(show: false),
                          alignment: BarChartAlignment.spaceEvenly,
                          maxY: _calculateMaxY(monthlyList),
                        ),
                      );
                    }
                    else {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No monthly sales available",
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  else {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20.0),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Unable to load Monthly Sales",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<MonthlySales> monthlySales) {
    final List<BarChartGroupData> barGroups = [];
    for (var i = monthlySales.length - 1; i > monthlySales.length - 7 && i > -1; i--) {
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: monthlySales[i].actualSales.toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }
    return barGroups;
  }

  // Dynamically calculate the maxY value based on the sales data
  double _calculateMaxY(List<MonthlySales> monthlySales) {
    final highestSale = monthlySales.map((e) => e.actualSales).reduce(max);
    return highestSale * 1.2;
  }



  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          '\$${rod.toY.toStringAsFixed(2)}',
          const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  FlTitlesData _getTitlesData(List<MonthlySales> monthlySales) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < monthlySales.length) {
              // Convert year and month to DateTime
              final date = DateTime(monthlySales[index].year, monthlySales[index].month);
              // Format the date as you like, for example: "Mar 23"
              final monthYear = DateFormat('MMM yy').format(date);
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(monthYear, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
              );
            }
            return const Text('');
          },
          reservedSize: 42,
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => const LinearGradient(
    colors: [
      Color.fromARGB(255, 228, 54, 244),
      Colors.amber,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
