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

