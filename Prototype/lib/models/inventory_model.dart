class InventoryItem {
  final String itemID;
  final String itemName;
  final String category;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final int criticalLvl;
  final String status;

  InventoryItem({
    required this.itemID,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.criticalLvl,
    required this.status,
  });


  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      itemID: json['item_id'],
      itemName: json['item_name'],
      category: json['category'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      criticalLvl: json['critical_level'],
      status: json['status'],
    );
  }
}
