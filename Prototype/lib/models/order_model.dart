class SalesOrder {
  final String orderID;
  final String orderDate;
  final String customerID;
  final String customerName;
  final String productID;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;
  final String employee;
  final String employeeID;

  SalesOrder({
    required this.orderID,
    required this.orderDate,
    required this.customerID,
    required this.customerName,
    required this.productID,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    required this.employee,
    required this.employeeID,
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      orderID: json['order_id'],
      orderDate: json['order_date'],
      customerID: json['customer_id'],
      customerName: json['customer_name'],
      productID: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      status: json['status'],
      employee: json['employee'],
      employeeID: json['employee_id'],
    );
  }
}

class Refunds {
  final String refundID;
  final String date;
  final String? customerID;
  final String customerName;
  final String productID;
  final String productName;
  final int? quantity;
  final double orderPrice;
  final double refundAmount;
  final String status;

  Refunds({
    required this.refundID,
    required this.date,
    this.customerID,
    required this.customerName,
    required this.productID,
    required this.productName,
    this.quantity,
    required this.orderPrice,
    required this.refundAmount,
    required this.status,
  });
}

// final List<SalesOrder> salesOrders = [
//   SalesOrder(
//     orderID: '1',
//     orderDate: '2023-01-15',
//     customerID: '1',
//     productID: '50',
//     productName: 'temp',
//     quantity: 10,
//     totalPrice: 500.0,
//     status: 'Completed',
//   ),
  // SalesOrder(
  //   orderNo: 2,
  //   date: '2023-01-27',
  //   customerID: 2,
  //   productID: 30,
  //   quantity: 20,
  //   totalPrice: 600.0,
  //   status: 'Completed',
  // ),
  // SalesOrder(
  //   orderNo: 3,
  //   date: '2023-02-28',
  //   customerID: 3,
  //   productID: 25,
  //   quantity: 15,
  //   totalPrice: 375.0,
  //   status: 'Completed',
  // ),
  // SalesOrder(
  //   orderNo: 4,
  //   date: '2023-03-10',
  //   customerID: 4,
  //   productID: 40,
  //   quantity: 12,
  //   totalPrice: 500.0,
  //   status: 'Completed',
  // ),
  // SalesOrder(
  //   orderNo: 5,
  //   date: '2023-04-05',
  //   customerID: 5,
  //   productID: 20,
  //   quantity: 18,
  //   totalPrice: 360.0,
  //   status: 'Completed',
  // ),
  // SalesOrder(
  //   orderNo: 6,
  //   date: '2023-05-20',
  //   customerID: 6,
  //   productID: 35,
  //   quantity: 22,
  //   totalPrice: 770.0,
  //   status: 'Pending',
  // ),
  // SalesOrder(
  //   orderNo: 7,
  //   date: '2023-06-08',
  //   customerID: 7,
  //   productID: 60,
  //   quantity: 8,
  //   totalPrice: 480.0,
  //   status: 'Pending',
  // ),
  // SalesOrder(
  //   orderNo: 8,
  //   date: '2023-07-01',
  //   customerID: 8,
  //   productID: 45,
  //   quantity: 25,
  //   totalPrice: 1125.0,
  //   status: 'Pending',
  // ),
  // SalesOrder(
  //   orderNo: 9,
  //   date: '2023-08-14',
  //   customerID: 9,
  //   productID: 15,
  //   quantity: 30,
  //   totalPrice: 450.0,
  //   status: 'Pending',
  // ),
  // SalesOrder(
  //   orderNo: 10,
  //   date: '2023-10-12',
  //   customerID: 10,
  //   productID: 55,
  //   quantity: 11,
  //   totalPrice: 605.0,
  //   status: 'Pending',
  // ),
// ];



