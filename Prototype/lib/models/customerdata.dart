
class CustomerData {
  final int customerID;
  final String customerName;
  final String contactPerson;
  final String email;
  final String phoneno;
  final String billingAddress;
  final String shippingAddress;
  final String? remark;

  CustomerData({
    required this.customerID,
    required this.customerName,
    required this.contactPerson,
    required this.email,
    required this.phoneno,
    required this.billingAddress,
    required this.shippingAddress,
    this.remark
  });
}


List<CustomerData> customerData = [
  CustomerData(
    customerID: 1,
    customerName: 'ABC Corporation',
    contactPerson: 'John Doe',
    email: 'john.doe@abccorp.com',
    phoneno: '555-1234',
    billingAddress: '123 Main St, Cityville',
    shippingAddress: '456 Shipping Ln, Cityville',
  ),
  CustomerData(
    customerID: 2,
    customerName: 'XYZ Ltd.',
    contactPerson: 'Jane Smith',
    email: 'jane.smith@xyzltd.com',
    phoneno: '555-5678',
    billingAddress: '789 Billing St, Townsville',
    shippingAddress: '012 Shipping Rd, Townsville',
  ),
  CustomerData(
    customerID: 3,
    customerName: 'Acme Enterprises',
    contactPerson: 'Bob Johnson',
    email: 'bob.johnson@acme.com',
    phoneno: '555-9876',
    billingAddress: '456 Billing Blvd, Villagetown',
    shippingAddress: '789 Shipping Ave, Villagetown',
  ),
  CustomerData(
    customerID: 4,
    customerName: 'Global Solutions Inc.',
    contactPerson: 'Alice Brown',
    email: 'alice.brown@globalsolutions.com',
    phoneno: '555-4321',
    billingAddress: '012 Billing Rd, Townsville',
    shippingAddress: '345 Shipping St, Townsville',
  ),
  CustomerData(
    customerID: 5,
    customerName: 'Tech Innovators Ltd.',
    contactPerson: 'Charlie Miller',
    email: 'charlie.miller@techinnovators.com',
    phoneno: '555-8765',
    billingAddress: '678 Billing Ave, Metropolis',
    shippingAddress: '901 Shipping Blvd, Metropolis',
  ),
  CustomerData(
    customerID: 6,
    customerName: 'Dynamic Enterprises',
    contactPerson: 'Eva Wilson',
    email: 'eva.wilson@dynamic.com',
    phoneno: '555-3456',
    billingAddress: '234 Billing St, Villagetown',
    shippingAddress: '567 Shipping Ave, Villagetown',
  ),
  CustomerData(
    customerID: 7,
    customerName: 'Innovate Solutions LLC',
    contactPerson: 'Chris Turner',
    email: 'chris.turner@innovate.com',
    phoneno: '555-6789',
    billingAddress: '890 Billing Blvd, Metropolis',
    shippingAddress: '123 Shipping Rd, Metropolis',
  ),
  CustomerData(
    customerID: 8,
    customerName: 'Tech Wizards Co.',
    contactPerson: 'Grace Rogers',
    email: 'grace.rogers@techwizards.com',
    phoneno: '555-2345',
    billingAddress: '456 Billing Ave, Cityville',
    shippingAddress: '789 Shipping St, Cityville',
  ),
  CustomerData(
    customerID: 9,
    customerName: 'Infinite Innovations Ltd.',
    contactPerson: 'David Turner',
    email: 'david.turner@infinite.com',
    phoneno: '555-8901',
    billingAddress: '012 Billing Rd, Villagetown',
    shippingAddress: '345 Shipping Ave, Villagetown',
  ),
  CustomerData(
    customerID: 10,
    customerName: 'Future Tech Solutions',
    contactPerson: 'Emily White',
    email: 'emily.white@futuretech.com',
    phoneno: '555-1234',
    billingAddress: '678 Billing St, Metropolis',
    shippingAddress: '901 Shipping Blvd, Metropolis',
  ),
  CustomerData(
    customerID: 11,
    customerName: 'Swift Solutions Inc.',
    contactPerson: 'Olivia Davis',
    email: 'olivia.davis@swiftsolutions.com',
    phoneno: '555-5678',
    billingAddress: '234 Billing Blvd, Townsville',
    shippingAddress: '567 Shipping Rd, Townsville',
  ),
  CustomerData(
    customerID: 12,
    customerName: 'Dynamic Systems Co.',
    contactPerson: 'Daniel Moore',
    email: 'daniel.moore@dynamicsystems.com',
    phoneno: '555-9876',
    billingAddress: '890 Billing St, Cityville',
    shippingAddress: '123 Shipping Ave, Cityville',
  ),
  CustomerData(
    customerID: 13,
    customerName: 'Eagle Enterprises Ltd.',
    contactPerson: 'Ava Clark',
    email: 'ava.clark@eagleenterprises.com',
    phoneno: '555-4321',
    billingAddress: '456 Billing Ave, Villagetown',
    shippingAddress: '789 Shipping St, Villagetown',
  ),
  CustomerData(
    customerID: 14,
    customerName: 'Innovative Solutions Co.',
    contactPerson: 'Henry Lee',
    email: 'henry.lee@innovativesolutions.com',
    phoneno: '555-8765',
    billingAddress: '012 Billing Rd, Metropolis',
    shippingAddress: '345 Shipping Blvd, Metropolis',
  ),
  CustomerData(
    customerID: 15,
    customerName: 'Global Innovations Ltd.',
    contactPerson: 'Sophia Hall',
    email: 'sophia.hall@globalinnovations.com',
    phoneno: '555-2345',
    billingAddress: '678 Billing St, Townsville',
    shippingAddress: '901 Shipping Ave, Townsville',
  ),
];