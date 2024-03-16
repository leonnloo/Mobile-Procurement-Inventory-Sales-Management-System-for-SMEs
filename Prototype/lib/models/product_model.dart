class ProductItem {
  final String productID;
  final String productName;
  final double unitPrice;
  final double sellingPrice;
  final int quantity;
  final String markup;
  final String margin;
  final int criticalLvl;
  final String status;

  ProductItem({
    required this.productID,
    required this.productName,
    required this.unitPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.markup,
    required this.margin,
    required this.criticalLvl,
    required this.status,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productID: json["product_id"],
      productName: json["product_name"],
      unitPrice: json["unit_price"],
      sellingPrice: json["selling_price"],
      quantity: json["quantity"],
      markup: json["markup"],
      margin: json["margin"],
      criticalLvl: json["critical_level"],
      status: json["status"],
    );
  }
}