class DispatchData {
  final int orderNo;
  final String date;
  final int customerID;
  final int productID;
  final String status;

  DispatchData({
    required this.orderNo,
    required this.date,
    required this.customerID,
    required this.productID,
    required this.status,
  });
}

final List<DispatchData> dispatchData = [
  DispatchData(
    orderNo: 1,
    date: '2023-01-15',
    customerID: 1,
    productID: 50,
    status: 'Packaged',
  ),
  DispatchData(
    orderNo: 2,
    date: '2023-01-27',
    customerID: 2,
    productID: 30,
    status: 'Shipped',
  ),
  DispatchData(
    orderNo: 3,
    date: '2023-02-28',
    customerID: 3,
    productID: 25,
    status: 'Delivered',
  ),
  DispatchData(
    orderNo: 4,
    date: '2023-03-10',
    customerID: 4,
    productID: 40,
    status: 'Packaged',
  ),
  DispatchData(
    orderNo: 5,
    date: '2023-04-05',
    customerID: 5,
    productID: 20,
    status: 'Shipped',
  ),
  DispatchData(
    orderNo: 6,
    date: '2023-05-20',
    customerID: 6,
    productID: 35,
    status: 'Delivered',
  ),
  DispatchData(
    orderNo: 7,
    date: '2023-06-08',
    customerID: 7,
    productID: 60,
    status: 'Shipped',
  ),
  DispatchData(
    orderNo: 8,
    date: '2023-07-01',
    customerID: 8,
    productID: 45,
    status: 'Shipped',
  ),
  DispatchData(
    orderNo: 9,
    date: '2023-08-14',
    customerID: 9,
    productID: 15,
    status: 'Delivered',
  ),
  DispatchData(
    orderNo: 10,
    date: '2023-09-20',
    customerID: 10,
    productID: 55,
    status: 'Packaged',
  ),
  DispatchData(
    orderNo: 11,
    date: '2023-10-12',
    customerID: 11,
    productID: 28,
    status: 'Shipped',
  ),
  DispatchData(
    orderNo: 12,
    date: '2023-11-25',
    customerID: 12,
    productID: 37,
    status: 'Delivered',
  ),
  DispatchData(
    orderNo: 13,
    date: '2023-12-08',
    customerID: 13,
    productID: 42,
    status: 'Packaged',
  ),
  DispatchData(
    orderNo: 14,
    date: '2024-01-15',
    customerID: 14,
    productID: 18,
    status: 'Shipped',
  ),
  DispatchData(
    orderNo: 15,
    date: '2024-02-20',
    customerID: 15,
    productID: 23,
    status: 'Delivered',
  ),
];
