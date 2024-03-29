class CustomerData {
  final String customerID;
  final String businessName;
  final String contactPerson;
  final String email;
  final String phoneNo;
  final String billingAddress;
  final String shippingAddress;
  final String? notes;

  CustomerData({
    required this.customerID,
    required this.businessName,
    required this.contactPerson,
    required this.email,
    required this.phoneNo,
    required this.billingAddress,
    required this.shippingAddress,
    this.notes
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      customerID: json['customer_id'],
      businessName: json['business_name'],
      contactPerson: json['contact_person'],
      email: json['email'],
      phoneNo: json['phone_number'],
      billingAddress: json['billing_address'],
      shippingAddress: json['shipping_address'],
      notes: json['notes'] ?? 'N/A',
    );
  }
}