class SupplierData {
  final String supplierID;
  final String businessName;
  final String contactPerson;
  final String email;
  final String phoneNo;
  final String address;
  final String? notes;

  SupplierData({
    required this.supplierID,
    required this.businessName,
    required this.contactPerson,
    required this.email,
    required this.phoneNo,
    required this.address,
    this.notes,
  });

  factory SupplierData.fromJson(Map<String, dynamic> json) {
    return SupplierData(
      supplierID: json['supplier_id'],
      businessName: json['business_name'],
      contactPerson: json['contact_person'],
      email: json['email'],
      phoneNo: json['phone_number'],
      address: json['address'],
      notes: json['notes'] ?? 'N/A',
    );
  }
}