class SalesTargetData {
  final String month;
  final double actualSalesVolume;
  final double targetSalesVolume;

  SalesTargetData({
    required this.month,
    required this.actualSalesVolume,
    required this.targetSalesVolume,
  });
}

final List<SalesTargetData> salesTargetData = [
  SalesTargetData(
    month: 'January',
    actualSalesVolume: 1000.0,
    targetSalesVolume: 1200.0,
  ),
  SalesTargetData(
    month: 'February',
    actualSalesVolume: 1100.0,
    targetSalesVolume: 1000.0,
  ),
  SalesTargetData(
    month: 'March',
    actualSalesVolume: 1050.0,
    targetSalesVolume: 1250.0,
  ),
  SalesTargetData(
    month: 'April',
    actualSalesVolume: 1150.0,
    targetSalesVolume: 1350.0,
  ),
  SalesTargetData(
    month: 'May',
    actualSalesVolume: 1250.0,
    targetSalesVolume: 1000.0,
  ),
  SalesTargetData(
    month: 'June',
    actualSalesVolume: 1200.0,
    targetSalesVolume: 1400.0,
  ),
  SalesTargetData(
    month: 'July',
    actualSalesVolume: 1150.0,
    targetSalesVolume: 900.0,
  ),
  SalesTargetData(
    month: 'August',
    actualSalesVolume: 1180.0,
    targetSalesVolume: 1380.0,
  ),
  SalesTargetData(
    month: 'September',
    actualSalesVolume: 1220.0,
    targetSalesVolume: 1200.0,
  ),
  SalesTargetData(
    month: 'October',
    actualSalesVolume: 1300.0,
    targetSalesVolume: 1500.0,
  ),
  SalesTargetData(
    month: 'November',
    actualSalesVolume: 1400.0,
    targetSalesVolume: 1800.0,
  ),
  SalesTargetData(
    month: 'December',
    actualSalesVolume: 1500.0,
    targetSalesVolume: 1700.0,
  ),
];
