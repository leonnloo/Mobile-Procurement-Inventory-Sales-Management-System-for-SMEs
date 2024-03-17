
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



// List<PurchasingOrder> fetchDataForCategory(String category) {

//   switch (category) {
//     case 'Past':
//         return pastOrders;
//     case 'Present':
//         return presentOrders;
//     default:
//       return [];
//   }
// }

// List<PurchasingOrder> pastOrders = [
//   PurchasingOrder(
//     orderNumber: 'PO00001',
//     supplierID: 1,
//     orderDate: '2023-01-24',
//     deliveryDate: '2023-01-30',
//     productID: 1,
//     totalPrice: 600,
//     quantity: 3,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00002',
//     supplierID: 2,
//     orderDate: '2023-01-25',
//     deliveryDate: '2023-02-01',
//     productID: 2,
//     totalPrice: 610,
//     quantity: 4,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00003',
//     supplierID: 3,
//     orderDate: '2023-01-26',
//     deliveryDate: '2023-02-02',
//     productID: 3,
//     totalPrice: 620,
//     quantity: 5,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00004',
//     supplierID: 4,
//     orderDate: '2023-01-27',
//     deliveryDate: '2023-02-03',
//     productID: 4,
//     totalPrice: 630,
//     quantity: 6,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00005',
//     supplierID: 5,
//     orderDate: '2023-01-28',
//     deliveryDate: '2023-02-04',
//     productID: 5,
//     totalPrice: 640,
//     quantity: 7,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00006',
//     supplierID: 6,
//     orderDate: '2023-01-29',
//     deliveryDate: '2023-02-05',
//     productID: 6,
//     totalPrice: 650,
//     quantity: 8,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00007',
//     supplierID: 7,
//     orderDate: '2023-01-30',
//     deliveryDate: '2023-02-06',
//     productID: 7,
//     totalPrice: 660,
//     quantity: 9,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00008',
//     supplierID: 8,
//     orderDate: '2023-01-31',
//     deliveryDate: '2023-02-07',
//     productID: 8,
//     totalPrice: 670,
//     quantity: 10,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00009',
//     supplierID: 9,
//     orderDate: '2023-02-01',
//     deliveryDate: '2023-02-08',
//     productID: 9,
//     totalPrice: 680,
//     quantity: 11,
//     status: 'Received',
//   ),
//   PurchasingOrder(
//     orderNumber: 'PO00010',
//     supplierID: 10,
//     orderDate: '2023-02-02',
//     deliveryDate: '2023-02-09',
//     productID: 10,
//     totalPrice: 690,
//     quantity: 12,
//     status: 'Received',
//   ),
//   // Past Order 11
//   PurchasingOrder(
//     orderNumber: 'PO00011',
//     supplierID: 11,
//     orderDate: '2023-02-03',
//     deliveryDate: '2023-02-10',
//     productID: 11,
//     totalPrice: 700,
//     quantity: 13,
//     status: 'Received',
//   ),
//   // Past Order 12
//   PurchasingOrder(
//     orderNumber: 'PO00012',
//     supplierID: 12,
//     orderDate: '2023-02-04',
//     deliveryDate: '2023-02-11',
//     productID: 12,
//     totalPrice: 710,
//     quantity: 14,
//     status: 'Received',
//   ),
//   // Past Order 13
//   PurchasingOrder(
//     orderNumber: 'PO00013',
//     supplierID: 13,
//     orderDate: '2023-02-05',
//     deliveryDate: '2023-02-12',
//     productID: 13,
//     totalPrice: 720,
//     quantity: 15,
//     status: 'Received',
//   ),
//   // Past Order 14
//   PurchasingOrder(
//     orderNumber: 'PO00014',
//     supplierID: 14,
//     orderDate: '2023-02-06',
//     deliveryDate: '2023-02-13',
//     productID: 14,
//     totalPrice: 730,
//     quantity: 16,
//     status: 'Received',
//   ),
//   // Past Order 15
//   PurchasingOrder(
//     orderNumber: 'PO00015',
//     supplierID: 15,
//     orderDate: '2023-02-07',
//     deliveryDate: '2023-02-14',
//     productID: 15,
//     totalPrice: 740,
//     quantity: 17,
//     status: 'Received',
//   ),
// ];

// List<PurchasingOrder> presentOrders = [
//   // Present Order 1
//   PurchasingOrder(
//     orderNumber: 'PO00020',
//     supplierID: 20,
//     orderDate: '2023-11-27',
//     deliveryDate: '2023-12-01',
//     productID: 12,
//     totalPrice: 300,
//     quantity: 2,
//     status: 'Delivering',
//   ),
//   // Present Order 2
//   PurchasingOrder(
//     orderNumber: 'PO00021',
//     supplierID: 21,
//     orderDate: '2023-11-28',
//     deliveryDate: '2023-12-02',
//     productID: 13,
//     totalPrice: 310,
//     quantity: 3,
//     status: 'Delivering',
//   ),
//   // Present Order 3
//   PurchasingOrder(
//     orderNumber: 'PO00022',
//     supplierID: 22,
//     orderDate: '2023-11-29',
//     deliveryDate: '2023-12-03',
//     productID: 14,
//     totalPrice: 320,
//     quantity: 4,
//     status: 'Delivering',
//   ),
//   // Present Order 4
//   PurchasingOrder(
//     orderNumber: 'PO00023',
//     supplierID: 23,
//     orderDate: '2023-11-30',
//     deliveryDate: '2023-12-04',
//     productID: 15,
//     totalPrice: 330,
//     quantity: 5,
//     status: 'Delivering',
//   ),
//   // Present Order 5
//   PurchasingOrder(
//     orderNumber: 'PO00024',
//     supplierID: 24,
//     orderDate: '2023-12-01',
//     deliveryDate: '2023-12-05',
//     productID: 16,
//     totalPrice: 340,
//     quantity: 6,
//     status: 'Delivering',
//   ),
//   // Present Order 6
//   PurchasingOrder(
//     orderNumber: 'PO00025',
//     supplierID: 25,
//     orderDate: '2023-12-02',
//     deliveryDate: '2023-12-06',
//     productID: 17,
//     totalPrice: 350,
//     quantity: 7,
//     status: 'Delivering',
//   ),
//   // Present Order 7
//   PurchasingOrder(
//     orderNumber: 'PO00026',
//     supplierID: 26,
//     orderDate: '2023-12-03',
//     deliveryDate: '2023-12-07',
//     productID: 18,
//     totalPrice: 360,
//     quantity: 8,
//     status: 'Delivering',
//   ),
//   // Present Order 8
//   PurchasingOrder(
//     orderNumber: 'PO00027',
//     supplierID: 27,
//     orderDate: '2023-12-04',
//     deliveryDate: '2023-12-08',
//     productID: 19,
//     totalPrice: 370,
//     quantity: 9,
//     status: 'Delivering',
//   ),
//   // Present Order 9
//   PurchasingOrder(
//     orderNumber: 'PO00028',
//     supplierID: 28,
//     orderDate: '2023-12-05',
//     deliveryDate: '2023-12-09',
//     productID: 20,
//     totalPrice: 380,
//     quantity: 10,
//     status: 'Delivering',
//   ),
//   // Present Order 10
//   PurchasingOrder(
//     orderNumber: 'PO00029',
//     supplierID: 29,
//     orderDate: '2023-12-06',
//     deliveryDate: '2023-12-10',
//     productID: 21,
//     totalPrice: 390,
//     quantity: 11,
//     status: 'Delivering',
//   ),
//   // Present Order 11
//   PurchasingOrder(
//     orderNumber: 'PO00030',
//     supplierID: 30,
//     orderDate: '2023-12-07',
//     deliveryDate: '2023-12-11',
//     productID: 22,
//     totalPrice: 400,
//     quantity: 3,
//     status: 'Delivering',
//   ),
//   // Present Order 12
//   PurchasingOrder(
//     orderNumber: 'PO00031',
//     supplierID: 31,
//     orderDate: '2023-12-08',
//     deliveryDate: '2023-12-12',
//     productID: 23,
//     totalPrice: 410,
//     quantity: 4,
//     status: 'Delivering',
//   ),
//   // Present Order 13
//   PurchasingOrder(
//     orderNumber: 'PO00032',
//     supplierID: 32,
//     orderDate: '2023-12-09',
//     deliveryDate: '2023-12-13',
//     productID: 24,
//     totalPrice: 420,
//     quantity: 5,
//     status: 'Delivering',
//   ),
//   // Present Order 14
//   PurchasingOrder(
//     orderNumber: 'PO00033',
//     supplierID: 33,
//     orderDate: '2023-12-10',
//     deliveryDate: '2023-12-14',
//     productID: 25,
//     totalPrice: 430,
//     quantity: 6,
//     status: 'Delivering',
//   ),
//   // Present Order 15
//   PurchasingOrder(
//     orderNumber: 'PO00034',
//     supplierID: 34,
//     orderDate: '2023-12-11',
//     deliveryDate: '2023-12-15',
//     productID: 26,
//     totalPrice: 440,
//     quantity: 7,
//     status: 'Delivering',
//   ),
// ];

