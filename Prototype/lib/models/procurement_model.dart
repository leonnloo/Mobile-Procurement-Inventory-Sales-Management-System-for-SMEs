
class PurchasingOrder {
  final String purchaseID;
  final String itemType;
  final String itemID;
  final String itemName;
  final String supplierName;
  final String orderDate;
  final String deliveryDate;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;

  PurchasingOrder({
    required this.purchaseID,
    required this.itemType,
    required this.itemID,
    required this.itemName,
    required this.supplierName,
    required this.orderDate,
    required this.deliveryDate,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
  });

  factory PurchasingOrder.fromJson(Map<String, dynamic> json) {
    return PurchasingOrder(
      purchaseID: json['purchase_id'],
      itemType: json['item_type'],
      itemID: json['item_id'],
      itemName: json['item_name'],
      supplierName: json['supplier_name'],
      orderDate: json['order_date'],
      deliveryDate: json['delivery_date'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      status: json['status'],
    );
  }
}