class Refunds{
  final String refundID;
  final String orderID;
  final String orderStatus;
  final String refundDate;
  final String customerID;
  final String customerName;
  final String productID;
  final String productName;
  final int refundQuantity;
  final double orderPrice;
  final double refundAmount;
  final String reason;

  Refunds({
    required this.refundID,
    required this.orderID,
    required this.orderStatus,
    required this.refundDate,
    required this.customerID,
    required this.customerName,
    required this.productID,
    required this.productName,
    required this.refundQuantity,
    required this.orderPrice,
    required this.refundAmount,
    required this.reason,
  });

  factory Refunds.fromJson(Map<String, dynamic> json) {
    return Refunds(
      refundID: json['refund_id'],
      orderID: json['order_id'],
      orderStatus: json['order_status'],
      refundDate: json['refund_date'],
      customerID: json['customer_id'],
      customerName: json['customer_name'],
      productID: json['product_id'],
      productName: json['product_name'],
      refundQuantity: json['refund_quantity'],
      orderPrice: json['order_price'],
      refundAmount: json['refund_amount'],
      reason: json['reason'],
    );
  }
}