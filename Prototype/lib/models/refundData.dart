class RefundData {
  final String customerName;
  final int customerID;
  final String date;
  final String reason;
  final double amount;
  final String status;

  RefundData({
    required this.customerName,
    required this.customerID,
    required this.date,
    required this.reason,
    required this.amount,
    required this.status,
  });
}

final List<RefundData> refundData = [
  RefundData(
    customerName: 'Alice Johnson',
    customerID: 3,
    date: '2023-02-10',
    reason: 'Received wrong item',
    amount: 30.0,
    status: 'Pending',
  ),
  RefundData(
    customerName: 'Bob Wilson',
    customerID: 4,
    date: '2023-03-18',
    reason: 'Item not as described',
    amount: 40.0,
    status: 'Approved',
  ),
  RefundData(
    customerName: 'Emily Brown',
    customerID: 5,
    date: '2023-04-25',
    reason: 'Item never arrived',
    amount: 20.0,
    status: 'Declined',
  ),
  RefundData(
    customerName: 'Michael Lee',
    customerID: 6,
    date: '2023-05-30',
    reason: 'Received damaged item',
    amount: 55.0,
    status: 'Pending',
  ),
  RefundData(
    customerName: 'Sophia Garcia',
    customerID: 7,
    date: '2023-06-05',
    reason: 'Changed mind about purchase',
    amount: 45.0,
    status: 'Approved',
  ),
  // 添加更多的退款数据...
];
