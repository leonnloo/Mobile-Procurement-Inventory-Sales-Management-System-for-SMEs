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
  final List<dynamic> monthlySales;

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
    required this.monthlySales,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    dynamic monthlyList;
    if (json['monthly_sales'] != null){
      monthlyList = json["monthly_sales"].map((x) => ProductMonthlySales.fromJson(x)).toList();
    }
    else {
      monthlyList = [];
    }
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
      monthlySales: monthlyList,
    );
  }
}

class ProductMonthlySales{
  final int year;
  final int month;
  final int quantitySold;
  final double totalPrice;

  ProductMonthlySales({
    required this.year,
    required this.month,
    required this.quantitySold,
    required this.totalPrice,
  });

  factory ProductMonthlySales.fromJson(Map<String, dynamic> json) {
    return ProductMonthlySales(
      year: json["year"],
      month: json["month"],
      quantitySold: json["quantity_sold"],
      totalPrice: json["total_price"],
    );
  }
}