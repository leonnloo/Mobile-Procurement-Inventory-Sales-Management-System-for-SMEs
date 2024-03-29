import 'dart:async';
import 'package:get/get.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/statistics/indicator.dart';

class ProductSalesPieChart extends StatefulWidget {
  const ProductSalesPieChart({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  final RequestUtil requestUtil = RequestUtil();
  int touchedIndex = -1;
  int _selectedMonth = 0;
  String _selectedYear = '';
  List<String> years = ['YTD'];
  List<String> monthNames = [
    'Total', // Add "Total" as the first option
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  double totalProfits = 0.0;
  late Map<String, double> percentages;
  double allSales = 0.0;
  final StreamController<String> _totalProfitsController = StreamController<String>.broadcast();
  final StreamController<Map<String, double>> _percentagesController = StreamController<Map<String, double>>.broadcast();
  final productController = Get.put(ProductController());


  @override
  void initState() {
    int intYear = DateTime.now().year;
    _selectedYear = years[0];
    for (int i = intYear; i >= intYear - 3; i--) {
      years.add(i.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    _totalProfitsController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product Sales',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                DropdownButton<String>(
                  value: _selectedYear,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                      if (_selectedYear == 'YTD') {
                        _selectedMonth = 0;
                      }
                      productController.getProducts().then((_) {
                        _totalProfitsController.add(totalProfits.toString()); // Push the new totalProfits to the stream
                      });
                    });
                  },
                  items: years.map<DropdownMenuItem<String>>((String year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<String>(
                  stream: calTotal,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    else if (snapshot.hasData) {
                      return Text(
                        '\$${snapshot.data}',
                        style: const TextStyle(fontSize: 32, color: Colors.green),
                      );
                    } else {
                      return const SizedBox(); // or any placeholder widget
                    }
                  }
                ),
                DropdownButton<int>(
                  value: _selectedMonth,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onChanged: _selectedYear == 'YTD' ? null : (int? newValue) { // Disable if 'YTD' is selected
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                  },
                  items: List.generate(monthNames.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(monthNames[index], style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                    );
                  }),
                  // Optionally, you can provide a different style or indication that the dropdown is disabled when 'YTD' is selected
                  disabledHint: Text(monthNames[_selectedMonth], style: TextStyle(color: Colors.grey)), // Show current month but in grey
                ),
              ],
            ),
            const SizedBox(height: 25),
            AspectRatio(
              aspectRatio: 1.9,
              child: Row(
                children: <Widget>[
                  const SizedBox(height: 18,),
                  _buildPieChart(),
                  _buildIndicators(),
                  const SizedBox(width: 28,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: FutureBuilder(
          future: productController.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return SizedBox(
                height: 150.0,
                child: Center(
                  child: Text('Unable to load', style: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.onSurface),),
                ),
              );
            } else {
              List<ProductItem> productItems = snapshot.data!;
              if (productItems.isNotEmpty){
                return PieChart(
                  PieChartData(
                    // pieTouchData: PieTouchData(
                    //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    //     setState(() {
                    //       if (!event.isInterestedForInteractions ||
                    //           pieTouchResponse == null ||
                    //           pieTouchResponse.touchedSection == null) {
                    //         touchedIndex = -1;
                    //         return;
                    //       }
                    //       touchedIndex = pieTouchResponse
                    //           .touchedSection!.touchedSectionIndex;
                    //     });
                    //   },
                    // ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 34,
                    sections: showingSections(productItems),
                  ),
                );
              }
              else {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No product sales available",
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
            }
          }
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<ProductItem> productItems) {
    percentages = calculatePercentage(productItems);
    // Create a list to hold the PieChartSectionData
    List<PieChartSectionData> sections = [];

    // Variable to keep track of the index for color selection
    int index = 0;

    percentages.forEach((productName, percentage) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      sections.add(PieChartSectionData(
        color: getColorForIndex(index),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%', // Show percentage with 1 decimal
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
      ));

      index++; // Increment index for the next iteration
    });

    return sections;
  }


  Color getColorForIndex(int index) {
  // Enhanced color palette for visual appeal and readability
  List<Color> colors = [
    const Color.fromARGB(255, 165, 77, 247), // Light Blue for contrast with dark navy & white
    const Color.fromARGB(255, 174, 209, 255), // Softer Blue for a lighter touch
    const Color.fromARGB(255, 102, 208, 235), // Slightly deeper Blue for variation
    const Color.fromARGB(255, 123, 125, 250), // Another shade of Blue to maintain harmony
    const Color(0xFFB2CCFF), // Very light Blue for subtle differentiation
    // You can add or replace with any other colors as per your design needs
  ];
  return colors[index % colors.length];
}

  
  Map<String, double> calculatePercentage(List<ProductItem> products) {
    allSales = 0.0;
    Map<String, double> productSales = {};

    for (ProductItem product in products) {
      double productTotalSales = 0.0;
      for (int i = 0; i < product.monthlySales.length; i++) {
        // Assuming sale is a map with `year` and `totalPrice`
        int saleYear = product.monthlySales[i].year;
        int saleMonth = product.monthlySales[i].month;
        double salePrice = product.monthlySales[i].totalPrice;
        if (_selectedYear == 'YTD' && saleYear == DateTime.now().year) {
          // Your existing logic for YTD
          productTotalSales += salePrice;
          allSales += salePrice;
        } else if (_selectedYear != 'YTD') { // Ensure _selectedYear is not 'YTD' before parsing
          int selectedYearInt = int.tryParse(_selectedYear) ?? DateTime.now().year; // Use current year as fallback
          if (saleYear == selectedYearInt && saleMonth == _selectedMonth) {
            productTotalSales += salePrice;
            allSales += salePrice;
          }
          else if (saleYear == selectedYearInt && _selectedMonth == 0) {
            productTotalSales += salePrice;
            allSales += salePrice;
          }
        }
      }
      if (productTotalSales > 0) {
        productSales[product.productName] = productTotalSales;
      }
    }

    // Sort products by sales in descending order and keep top 3
    var sortedKeys = productSales.keys.toList(growable: false)
      ..sort((k1, k2) => productSales[k2]!.compareTo(productSales[k1]!));

    Map<String, double> sortedProductSales = {
      for (var key in sortedKeys) key: productSales[key]!,
    };

    // Create a new map with top 3 products and others
    Map<String, double> finalProductSales = {};
    double otherSales = 0.0;
    int count = 0;
    sortedProductSales.forEach((key, value) {
      if (count < 3) {
        finalProductSales[key] = value;
      } else {
        otherSales += value;
      }
      count++;
    });
    if (otherSales > 0) finalProductSales['Others'] = otherSales;

    // Convert sales to percentage of total
    finalProductSales.updateAll((key, value) => (value / allSales) * 100);
    _totalProfitsController.sink.add(allSales.toStringAsFixed(2));
    _percentagesController.sink.add(finalProductSales);
    return finalProductSales;
  }
  
Widget _buildIndicators() {
  return StreamBuilder<Map<String, double>>(
    stream: percentagesStream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Container(); // Placeholder/loading indicator
      }

      final percentages = snapshot.data!;
      List<Widget> indicators = [];
      int index = 0;

      percentages.forEach((productName, percentage) {
        final color = getColorForIndex(index);
        // Wrap Indicator with constraints to encourage text wrapping
        indicators.add(
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.25), // Example constraint
            child: Indicator(
              color: color,
              text: productName,
              isSquare: true,
              textColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
        indicators.add(const SizedBox(height: 4,));
        index++;
      });

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: indicators,
          ),
        ),
      );
    },
  );
}







  Stream<String> get calTotal => _totalProfitsController.stream;
  Stream<Map<String, double>> get percentagesStream => _percentagesController.stream;
  
}