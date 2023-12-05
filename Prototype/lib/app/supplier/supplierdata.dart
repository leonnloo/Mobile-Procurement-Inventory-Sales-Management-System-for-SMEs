
class SupplierData {
  final int supplierID;
  final String supplierName;
  final String contactPerson;
  final String email;
  final String phoneno;
  final String address;
  final String? remark;

  SupplierData({
    required this.supplierID,
    required this.supplierName,
    required this.contactPerson,
    required this.email,
    required this.phoneno,
    required this.address,
    this.remark,
  });
}


List<SupplierData> suppliers = [
  SupplierData(
    supplierID: 1,
    supplierName: 'Supplier A',
    contactPerson: 'John Doe',
    email: 'john.doe@suppliera.com',
    phoneno: '123-456-7890',
    address: '123 Main Street, Cityville',
  ),
  SupplierData(
    supplierID: 2,
    supplierName: 'Supplier B',
    contactPerson: 'Jane Smith',
    email: 'jane.smith@supplierb.com',
    phoneno: '987-654-3210',
    address: '456 Oak Avenue, Townsville',
  ),
  SupplierData(
    supplierID: 3,
    supplierName: 'Supplier C',
    contactPerson: 'Bob Johnson',
    email: 'bob.johnson@supplierc.com',
    phoneno: '555-789-1234',
    address: '789 Elm Street, Villagetown',
  ),
  SupplierData(
    supplierID: 4,
    supplierName: 'Supplier D',
    contactPerson: 'Alice Davis',
    email: 'alice.davis@supplierd.com',
    phoneno: '321-987-6543',
    address: '101 Pine Lane, Hamletville',
  ),
  SupplierData(
    supplierID: 5,
    supplierName: 'Supplier E',
    contactPerson: 'Charlie Brown',
    email: 'charlie.brown@supplere.com',
    phoneno: '444-222-8888',
    address: '222 Maple Street, Suburbia',
  ),
  SupplierData(
    supplierID: 6,
    supplierName: 'Supplier F',
    contactPerson: 'Eve Anderson',
    email: 'eve.anderson@supplierf.com',
    phoneno: '777-111-3333',
    address: '333 Oak Lane, Countryside',
  ),
  SupplierData(
    supplierID: 7,
    supplierName: 'Supplier G',
    contactPerson: 'George Wilson',
    email: 'george.wilson@supplerg.com',
    phoneno: '999-666-4444',
    address: '444 Cedar Street, Metropolis',
  ),
  SupplierData(
    supplierID: 8,
    supplierName: 'Supplier H',
    contactPerson: 'Helen Carter',
    email: 'helen.carter@supplierh.com',
    phoneno: '888-333-7777',
    address: '555 Birch Avenue, Uptown',
  ),
  SupplierData(
    supplierID: 9,
    supplierName: 'Supplier I',
    contactPerson: 'Ivan Rodriguez',
    email: 'ivan.rodriguez@supplieri.com',
    phoneno: '666-444-9999',
    address: '666 Pine Lane, Outskirts',
  ),
  SupplierData(
    supplierID: 10,
    supplierName: 'Supplier J',
    contactPerson: 'Mark Johnson',
    email: 'mark.johnson@supplierj.com',
    phoneno: '555-123-4567',
    address: '789 Pine Street, Villagetown',
  ),
  SupplierData(
    supplierID: 11,
    supplierName: 'Supplier K',
    contactPerson: 'Karen White',
    email: 'karen.white@supplierk.com',
    phoneno: '777-888-9999',
    address: '111 Cedar Avenue, Downtown',
  ),
  SupplierData(
    supplierID: 12,
    supplierName: 'Supplier L',
    contactPerson: 'Larry Green',
    email: 'larry.green@supplierl.com',
    phoneno: '333-222-1111',
    address: '222 Birch Lane, Suburbia',
  ),
  SupplierData(
    supplierID: 13,
    supplierName: 'Supplier M',
    contactPerson: 'Mary Johnson',
    email: 'mary.johnson@supplierm.com',
    phoneno: '444-555-6666',
    address: '333 Maple Street, Countryside',
  ),
  SupplierData(
    supplierID: 14,
    supplierName: 'Supplier N',
    contactPerson: 'Nancy Brown',
    email: 'nancy.brown@suppliern.com',
    phoneno: '999-888-7777',
    address: '444 Pine Avenue, Metropolis',
  ),
  SupplierData(
    supplierID: 15,
    supplierName: 'Supplier O',
    contactPerson: 'Oliver Davis',
    email: 'oliver.davis@suppliero.com',
    phoneno: '111-222-3333',
    address: '555 Oak Lane, Outskirts',
  ),
];