import 'package:flutter/material.dart';
import 'package:prototype/models/procurementdata.dart';

class OrderDetailScreen extends StatelessWidget {
  final PurchasingOrder order;

  OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procurement Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Supplier Information', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SupplierInformation(), // Display supplier's information
            SizedBox(height: 16.0),
            Text('Order Information', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            OrderInformation(order: order), // Display order information
          ],
        ),
      ),
    );
  }
}

class SupplierInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.business),
          title: Text('Supplier A'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('+123456789'),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('supplier@example.com'),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('John Doe'),
        ),
      ],
    );
  }
}

class OrderInformation extends StatelessWidget {
  final PurchasingOrder order;

  OrderInformation({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.receipt),
          title: Text('Order Number: ${order.orderNumber}'),
        ),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text('Order Date: ${order.orderDate}'), // Corrected to orderDate
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text('Total Amount: \$${order.totalPrice.toString()}'), // Corrected to totalPrice
        ),
        ListTile(
          leading: Icon(Icons.delivery_dining),
          title: Text('Delivery Status: ${order.productID}'), // You might want to replace productID with the actual delivery status field
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Supplier Name: ${order.totalPrice}'), // You might want to replace totalPrice with the actual supplier name field
        ),
      ],
    );
  }
}
