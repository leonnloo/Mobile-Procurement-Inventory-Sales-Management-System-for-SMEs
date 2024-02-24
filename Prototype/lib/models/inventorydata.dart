class InventoryItem {
  final int itemID;
  final String itemName;
  final String category;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;

  InventoryItem({
    required this.itemID,
    required this.itemName,
    required this.category,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
  });
}


final List<InventoryItem> inventoryItems = [
  InventoryItem(
    itemID: 1,
    itemName: 'Item A',
    category: 'Trading Goods',
    quantity: 50,
    unitPrice: 10.0,
    totalPrice: 500.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 2,
    itemName: 'Item B',
    category: 'Non-stock materials',
    quantity: 30,
    unitPrice: 20.0,
    totalPrice: 600.0,
    status: 'Out of Stock',
  ),
  InventoryItem(
    itemID: 3,
    itemName: 'Item C',
    category: 'Services',
    quantity: 25,
    unitPrice: 15.0,
    totalPrice: 375.0,
    status: 'Low Stock',
  ),
  InventoryItem(
    itemID: 4,
    itemName: 'Item D',
    category: 'Trading Goods',
    quantity: 40,
    unitPrice: 12.5,
    totalPrice: 500.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 5,
    itemName: 'Item E',
    category: 'Non-stock materials',
    quantity: 20,
    unitPrice: 18.0,
    totalPrice: 360.0,
    status: 'Out of Stock',
  ),
  InventoryItem(
    itemID: 6,
    itemName: 'Item F',
    category: 'Services',
    quantity: 35,
    unitPrice: 22.0,
    totalPrice: 770.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 7,
    itemName: 'Item G',
    category: 'Trading Goods',
    quantity: 60,
    unitPrice: 8.0,
    totalPrice: 480.0,
    status: 'Out of Stock',
  ),
  InventoryItem(
    itemID: 8,
    itemName: 'Item H',
    category: 'Non-stock materials',
    quantity: 45,
    unitPrice: 25.0,
    totalPrice: 1125.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 9,
    itemName: 'Item I',
    category: 'Services',
    quantity: 15,
    unitPrice: 30.0,
    totalPrice: 450.0,
    status: 'Out of Stock',
  ),
  InventoryItem(
    itemID: 10,
    itemName: 'Item J',
    category: 'Trading Goods',
    quantity: 55,
    unitPrice: 11.0,
    totalPrice: 605.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 10,
    itemName: 'Item J',
    category: 'Trading Goods',
    quantity: 55,
    unitPrice: 11.0,
    totalPrice: 605.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 10,
    itemName: 'Item J',
    category: 'Trading Goods',
    quantity: 55,
    unitPrice: 11.0,
    totalPrice: 605.0,
    status: 'In Stock',
  ),
  InventoryItem(
    itemID: 10,
    itemName: 'Item J',
    category: 'Trading Goods',
    quantity: 55,
    unitPrice: 11.0,
    totalPrice: 605.0,
    status: 'In Stock',
  ),
];
