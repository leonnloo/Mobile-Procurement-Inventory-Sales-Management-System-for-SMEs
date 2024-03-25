class MonthlySales {
  final int year;
  final int month;
  final double actualSales;
  final double targetSales;


  MonthlySales({required this.year, required this.month, required this.actualSales, required this.targetSales});

  factory MonthlySales.fromJson(Map<String, dynamic> json) {
    return MonthlySales(
      year: json['year'],
      month: json['month'],
      actualSales: json['actual_sales'],
      targetSales: json['target_sales'],
    );
  }
}