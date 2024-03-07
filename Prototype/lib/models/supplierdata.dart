
import 'package:prototype/models/orderdata.dart';

class SupplierData {
  final String supplierID;
  final String businessName;
  final String contactPerson;
  final String email;
  final String phoneNo;
  final String address;
  final List<SalesOrder>? pastOrder;
  final String? notes;

  SupplierData({
    required this.supplierID,
    required this.businessName,
    required this.contactPerson,
    required this.email,
    required this.phoneNo,
    required this.address,
    this.pastOrder,
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
      pastOrder: (json['past_order'] as List<dynamic>?)
        ?.map((data) => SalesOrder.fromJson(data))
        .toList(),
      notes: json['notes'] ?? 'N/A',
    );
  }
}


// List<SupplierData> suppliers = [
//   SupplierData(
//     supplierID: 1,
//     businessName: 'Supplier A',
//     contactPerson: 'John Doe',
//     email: 'john.doe@suppliera.com',
//     phoneNo: '123-456-7890',
//     address: '123 Main Street, Cityville',
//   ),
//   SupplierData(
//     supplierID: 2,
//     businessName: 'Supplier B',
//     contactPerson: 'Jane Smith',
//     email: 'jane.smith@supplierb.com',
//     phoneNo: '987-654-3210',
//     address: '456 Oak Avenue, Townsville',
//   ),
//   SupplierData(
//     supplierID: 3,
//     businessName: 'Supplier C',
//     contactPerson: 'Bob Johnson',
//     email: 'bob.johnson@supplierc.com',
//     phoneNo: '555-789-1234',
//     address: '789 Elm Street, Villagetown',
//   ),
//   SupplierData(
//     supplierID: 4,
//     businessName: 'Supplier D',
//     contactPerson: 'Alice Davis',
//     email: 'alice.davis@supplierd.com',
//     phoneNo: '321-987-6543',
//     address: '101 Pine Lane, Hamletville',
//   ),
//   SupplierData(
//     supplierID: 5,
//     businessName: 'Supplier E',
//     contactPerson: 'Charlie Brown',
//     email: 'charlie.brown@supplere.com',
//     phoneNo: '444-222-8888',
//     address: '222 Maple Street, Suburbia',
//   ),
//   SupplierData(
//     supplierID: 6,
//     businessName: 'Supplier F',
//     contactPerson: 'Eve Anderson',
//     email: 'eve.anderson@supplierf.com',
//     phoneNo: '777-111-3333',
//     address: '333 Oak Lane, Countryside',
//   ),
//   SupplierData(
//     supplierID: 7,
//     businessName: 'Supplier G',
//     contactPerson: 'George Wilson',
//     email: 'george.wilson@supplerg.com',
//     phoneNo: '999-666-4444',
//     address: '444 Cedar Street, Metropolis',
//   ),
//   SupplierData(
//     supplierID: 8,
//     businessName: 'Supplier H',
//     contactPerson: 'Helen Carter',
//     email: 'helen.carter@supplierh.com',
//     phoneNo: '888-333-7777',
//     address: '555 Birch Avenue, Uptown',
//   ),
//   SupplierData(
//     supplierID: 9,
//     businessName: 'Supplier I',
//     contactPerson: 'Ivan Rodriguez',
//     email: 'ivan.rodriguez@supplieri.com',
//     phoneNo: '666-444-9999',
//     address: '666 Pine Lane, Outskirts',
//   ),
//   SupplierData(
//     supplierID: 10,
//     businessName: 'Supplier J',
//     contactPerson: 'Mark Johnson',
//     email: 'mark.johnson@supplierj.com',
//     phoneNo: '555-123-4567',
//     address: '789 Pine Street, Villagetown',
//   ),
//   SupplierData(
//     supplierID: 11,
//     businessName: 'Supplier K',
//     contactPerson: 'Karen White',
//     email: 'karen.white@supplierk.com',
//     phoneNo: '777-888-9999',
//     address: '111 Cedar Avenue, Downtown',
//   ),
//   SupplierData(
//     supplierID: 12,
//     businessName: 'Supplier L',
//     contactPerson: 'Larry Green',
//     email: 'larry.green@supplierl.com',
//     phoneNo: '333-222-1111',
//     address: '222 Birch Lane, Suburbia',
//   ),
//   SupplierData(
//     supplierID: 13,
//     businessName: 'Supplier M',
//     contactPerson: 'Mary Johnson',
//     email: 'mary.johnson@supplierm.com',
//     phoneNo: '444-555-6666',
//     address: '333 Maple Street, Countryside',
//   ),
//   SupplierData(
//     supplierID: 14,
//     businessName: 'Supplier N',
//     contactPerson: 'Nancy Brown',
//     email: 'nancy.brown@suppliern.com',
//     phoneNo: '999-888-7777',
//     address: '444 Pine Avenue, Metropolis',
//   ),
//   SupplierData(
//     supplierID: 15,
//     businessName: 'Supplier O',
//     contactPerson: 'Oliver Davis',
//     email: 'oliver.davis@suppliero.com',
//     phoneNo: '111-222-3333',
//     address: '555 Oak Lane, Outskirts',
//   ),
// ];