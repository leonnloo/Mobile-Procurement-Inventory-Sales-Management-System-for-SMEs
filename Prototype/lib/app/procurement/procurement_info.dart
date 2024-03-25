import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/models/edit_type.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/models/supplier_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/appbar/info_appbar.dart';

final RequestUtil requestUtil = RequestUtil();
class OrderDetailScreen extends StatelessWidget {
  final PurchasingOrder order;
  final Function updateData;
  const OrderDetailScreen({super.key, required this.order, required this.updateData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(currentTitle: 'Purchase Details', currentData: order, editType: EditType.procurement, updateData: updateData,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Order Information', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              OrderInformation(order: order), // Display order information
              const SizedBox(height: 16.0),
              const Text('Supplier Information', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              SupplierInformation(order: order), // Display supplier's information
            ],
          ),
        ),
      ),
    );
  }
}

class SupplierInformation extends StatelessWidget {
  const SupplierInformation({super.key, required this.order});
  final PurchasingOrder order;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSupplierData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load supplier data",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final supplier = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.business),
                  title: Text(supplier.businessName),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(supplier.phoneNo),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(supplier.email),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(supplier.contactPerson),
                ),
              ],
            );
          }
          else {
            return Container();
          }
      }
    );
  }

  Future<SupplierData> _fetchSupplierData() async {
    try {
      final supplier = await requestUtil.getSupplier(order.supplierName);
      if (supplier.statusCode == 200) {
        dynamic jsonData = jsonDecode(supplier.body);
        SupplierData supplierData = SupplierData.fromJson(jsonData);
        return supplierData;
      } else {
        throw Exception('Unable to fetch supplier data.');
      }
    } catch (error) {
      // print('Error in _fetchSupplierData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }
}

class OrderInformation extends StatelessWidget {
  final PurchasingOrder order;

  const OrderInformation({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.receipt),
          title: Text('Order ID: ${order.purchaseID}'),
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: Text('Type: ${order.itemType}'),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: Text('Item ID: ${order.itemID}'),
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: Text('Item: ${order.itemName}'),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text('Order Date: ${order.orderDate}'), // Corrected to orderDate
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: Text('Order Date: ${order.deliveryDate}'), // Corrected to orderDate
        ),
        ListTile(
          leading: const Icon(Icons.delivery_dining),
          title: Text('Quantity: ${order.quantity.toString()}'), // You might want to replace productID with the actual delivery status field
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: Text('Unit Price: \$${order.unitPrice.toStringAsFixed(2).toString()}'), // Corrected to totalPrice
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: Text('Total Amount: \$${order.totalPrice.toStringAsFixed(2).toString()}'), // Corrected to totalPrice
        ),

        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: Text('Status: ${order.status}'), // You might want to replace totalPrice with the actual supplier name field
        ),
      ],
    );
  }
}
