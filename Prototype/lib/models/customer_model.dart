import 'package:prototype/models/order_model.dart';

class PurchasingOrder {
  final String customerID;
  final String businessName;
  final String contactPerson;
  final String email;
  final String phoneNo;
  final String billingAddress;
  final String shippingAddress;
  final List<SalesOrder>? pastOrder;
  final String? notes;

  PurchasingOrder({
    required this.customerID,
    required this.businessName,
    required this.contactPerson,
    required this.email,
    required this.phoneNo,
    required this.billingAddress,
    required this.shippingAddress,
    this.pastOrder,
    this.notes
  });

  factory PurchasingOrder.fromJson(Map<String, dynamic> json) {
    return PurchasingOrder(
      customerID: json['customer_id'],
      businessName: json['business_name'],
      contactPerson: json['contact_person'],
      email: json['email'],
      phoneNo: json['phone_number'],
      billingAddress: json['billing_address'],
      shippingAddress: json['shipping_address'],
      pastOrder: (json['past_order'] as List<dynamic>?)
        ?.map((data) => SalesOrder.fromJson(data))
        .toList(),
      notes: json['notes'] ?? 'N/A',
    );
  }
}


// List<CustomerData> customerData = [
//   CustomerData(
//     customerID: 1,
//     businessName: 'ABC Corporation',
//     contactPerson: 'John Doe',
//     email: 'john.doe@abccorp.com',
//     phoneNo: '555-1234',
//     billingAddress: '123 Main St, Cityville',
//     shippingAddress: '456 Shipping Ln, Cityville',
//   ),
//   CustomerData(
//     customerID: 2,
//     businessName: 'XYZ Ltd.',
//     contactPerson: 'Jane Smith',
//     email: 'jane.smith@xyzltd.com',
//     phoneNo: '555-5678',
//     billingAddress: '789 Billing St, Townsville',
//     shippingAddress: '012 Shipping Rd, Townsville',
//   ),
//   CustomerData(
//     customerID: 3,
//     businessName: 'Acme Enterprises',
//     contactPerson: 'Bob Johnson',
//     email: 'bob.johnson@acme.com',
//     phoneNo: '555-9876',
//     billingAddress: '456 Billing Blvd, Villagetown',
//     shippingAddress: '789 Shipping Ave, Villagetown',
//   ),
//   CustomerData(
//     customerID: 4,
//     businessName: 'Global Solutions Inc.',
//     contactPerson: 'Alice Brown',
//     email: 'alice.brown@globalsolutions.com',
//     phoneNo: '555-4321',
//     billingAddress: '012 Billing Rd, Townsville',
//     shippingAddress: '345 Shipping St, Townsville',
//   ),
//   CustomerData(
//     customerID: 5,
//     businessName: 'Tech Innovators Ltd.',
//     contactPerson: 'Charlie Miller',
//     email: 'charlie.miller@techinnovators.com',
//     phoneNo: '555-8765',
//     billingAddress: '678 Billing Ave, Metropolis',
//     shippingAddress: '901 Shipping Blvd, Metropolis',
//   ),
//   CustomerData(
//     customerID: 6,
//     businessName: 'Dynamic Enterprises',
//     contactPerson: 'Eva Wilson',
//     email: 'eva.wilson@dynamic.com',
//     phoneNo: '555-3456',
//     billingAddress: '234 Billing St, Villagetown',
//     shippingAddress: '567 Shipping Ave, Villagetown',
//   ),
//   CustomerData(
//     customerID: 7,
//     businessName: 'Innovate Solutions LLC',
//     contactPerson: 'Chris Turner',
//     email: 'chris.turner@innovate.com',
//     phoneNo: '555-6789',
//     billingAddress: '890 Billing Blvd, Metropolis',
//     shippingAddress: '123 Shipping Rd, Metropolis',
//   ),
//   CustomerData(
//     customerID: 8,
//     businessName: 'Tech Wizards Co.',
//     contactPerson: 'Grace Rogers',
//     email: 'grace.rogers@techwizards.com',
//     phoneNo: '555-2345',
//     billingAddress: '456 Billing Ave, Cityville',
//     shippingAddress: '789 Shipping St, Cityville',
//   ),
//   CustomerData(
//     customerID: 9,
//     businessName: 'Infinite Innovations Ltd.',
//     contactPerson: 'David Turner',
//     email: 'david.turner@infinite.com',
//     phoneNo: '555-8901',
//     billingAddress: '012 Billing Rd, Villagetown',
//     shippingAddress: '345 Shipping Ave, Villagetown',
//   ),
//   CustomerData(
//     customerID: 10,
//     businessName: 'Future Tech Solutions',
//     contactPerson: 'Emily White',
//     email: 'emily.white@futuretech.com',
//     phoneNo: '555-1234',
//     billingAddress: '678 Billing St, Metropolis',
//     shippingAddress: '901 Shipping Blvd, Metropolis',
//   ),
//   CustomerData(
//     customerID: 11,
//     businessName: 'Swift Solutions Inc.',
//     contactPerson: 'Olivia Davis',
//     email: 'olivia.davis@swiftsolutions.com',
//     phoneNo: '555-5678',
//     billingAddress: '234 Billing Blvd, Townsville',
//     shippingAddress: '567 Shipping Rd, Townsville',
//   ),
//   CustomerData(
//     customerID: 12,
//     businessName: 'Dynamic Systems Co.',
//     contactPerson: 'Daniel Moore',
//     email: 'daniel.moore@dynamicsystems.com',
//     phoneNo: '555-9876',
//     billingAddress: '890 Billing St, Cityville',
//     shippingAddress: '123 Shipping Ave, Cityville',
//   ),
//   CustomerData(
//     customerID: 13,
//     businessName: 'Eagle Enterprises Ltd.',
//     contactPerson: 'Ava Clark',
//     email: 'ava.clark@eagleenterprises.com',
//     phoneNo: '555-4321',
//     billingAddress: '456 Billing Ave, Villagetown',
//     shippingAddress: '789 Shipping St, Villagetown',
//   ),
//   CustomerData(
//     customerID: 14,
//     businessName: 'Innovative Solutions Co.',
//     contactPerson: 'Henry Lee',
//     email: 'henry.lee@innovativesolutions.com',
//     phoneNo: '555-8765',
//     billingAddress: '012 Billing Rd, Metropolis',
//     shippingAddress: '345 Shipping Blvd, Metropolis',
//   ),
//   CustomerData(
//     customerID: 15,
//     businessName: 'Global Innovations Ltd.',
//     contactPerson: 'Sophia Hall',
//     email: 'sophia.hall@globalinnovations.com',
//     phoneNo: '555-2345',
//     billingAddress: '678 Billing St, Townsville',
//     shippingAddress: '901 Shipping Ave, Townsville',
//   ),
// ];