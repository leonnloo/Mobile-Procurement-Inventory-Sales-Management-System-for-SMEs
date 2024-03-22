class SalesTargetData {
  final int year;
  final int month;
  final double actualSalesVolume;
  final double targetSalesVolume;

  SalesTargetData({
    required this.year,
    required this.month,
    required this.actualSalesVolume,
    required this.targetSalesVolume,
  });

  factory SalesTargetData.fromJson(Map<String, dynamic> json) {
    return SalesTargetData(
      year: json["year"],
      month: json['month'],
      actualSalesVolume: json['actual_sales'],
      targetSalesVolume: json['target_sales'],
    );
  }
}