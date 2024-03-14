import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prototype/app/product/get_product.dart';
import 'package:prototype/resources/app_colors.dart';
import 'package:prototype/models/procurement_model.dart';

class MonthlyPurchaseStatic extends StatefulWidget {
  const MonthlyPurchaseStatic({super.key});

  @override
  State<MonthlyPurchaseStatic> createState() => _MonthlyPurchaseStaticState();
}

class _MonthlyPurchaseStaticState extends State<MonthlyPurchaseStatic> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showPast = false;
  List<PurchasingOrder> pastOrders = [];
  List<PurchasingOrder> presentOrders = [];


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showPast ? pastData() : presentData(),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          height: 34,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF64A8E0)), // 设置文本颜色为蓝色
            ),
            onPressed: () {
              setState(() {
                showPast = !showPast;
              });
            },
            child: Text(
              showPast ? 'Received' : 'Delivering',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('JAN', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 4:
        text = const Text('MAY', style: style);
        break;
      case 6:
        text = const Text('JULY', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      case 10:
        text = const Text('NOV', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 5:
        text = const Text('Monthly Purchase', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 3:
        text = '3k';
        break;
      case 6:
        text = '6k';
        break;
      case 9:
        text = '9k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData presentData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: 1,
            getTitlesWidget: topTitleWidgets,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0,
                (calculateTotalPriceByMonth(presentOrders, '2023-1') / 1000)),
            FlSpot(1,
                (calculateTotalPriceByMonth(presentOrders, '2023-2') / 1000)),
            FlSpot(2,
                (calculateTotalPriceByMonth(presentOrders, '2023-03') / 1000)),
            FlSpot(3,
                (calculateTotalPriceByMonth(presentOrders, '2023-04') / 1000)),
            FlSpot(4,
                (calculateTotalPriceByMonth(presentOrders, '2023-05') / 1000)),
            FlSpot(5,
                (calculateTotalPriceByMonth(presentOrders, '2023-06') / 1000)),
            FlSpot(6,
                (calculateTotalPriceByMonth(presentOrders, '2023-07') / 1000)),
            FlSpot(7,
                (calculateTotalPriceByMonth(presentOrders, '2023-08') / 1000)),
            FlSpot(8,
                (calculateTotalPriceByMonth(presentOrders, '2023-09') / 1000)),
            FlSpot(9,
                (calculateTotalPriceByMonth(presentOrders, '2023-10') / 1000)),
            FlSpot(10,
                (calculateTotalPriceByMonth(presentOrders, '2023-11') / 1000)),
            FlSpot(11,
                (calculateTotalPriceByMonth(presentOrders, '2023-12') / 1000)),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData pastData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: 1,
            getTitlesWidget: topTitleWidgets,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(
                0, (calculateTotalPriceByMonth(pastOrders, '2023-1') / 1000)),
            FlSpot(
                1, (calculateTotalPriceByMonth(pastOrders, '2023-02') / 1000)),
            FlSpot(
                2, (calculateTotalPriceByMonth(pastOrders, '2023-03') / 1000)),
            FlSpot(
                3, (calculateTotalPriceByMonth(pastOrders, '2023-04') / 1000)),
            FlSpot(
                4, (calculateTotalPriceByMonth(pastOrders, '2023-05') / 1000)),
            FlSpot(
                5, (calculateTotalPriceByMonth(pastOrders, '2023-06') / 1000)),
            FlSpot(
                6, (calculateTotalPriceByMonth(pastOrders, '2023-07') / 1000)),
            FlSpot(
                7, (calculateTotalPriceByMonth(pastOrders, '2023-08') / 1000)),
            FlSpot(
                8, (calculateTotalPriceByMonth(pastOrders, '2023-09') / 1000)),
            FlSpot(
                9, (calculateTotalPriceByMonth(pastOrders, '2023-10') / 1000)),
            FlSpot(
                10, (calculateTotalPriceByMonth(pastOrders, '2023-11') / 1000)),
            FlSpot(
                11, (calculateTotalPriceByMonth(pastOrders, '2023-12') / 1000)),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
