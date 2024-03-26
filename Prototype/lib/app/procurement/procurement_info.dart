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
              Text('Order Information', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 16.0),
              OrderInformation(order: order), // Display order information
              const SizedBox(height: 16.0),
              Text('Supplier Information', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
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
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load supplier data",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
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
                  leading: Icon(Icons.business, color: Theme.of(context).colorScheme.onSurface,),
                  title: Text(supplier.businessName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Theme.of(context).colorScheme.onSurface,),
                  title: Text(supplier.phoneNo, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                ),
                ListTile(
                  leading: Icon(Icons.email, color: Theme.of(context).colorScheme.onSurface,),
                  title: Text(supplier.email, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface,),
                  title: Text(supplier.contactPerson, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
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
          leading: Icon(Icons.receipt, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Order ID: ${order.purchaseID}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        ),
        ListTile(
          leading: Icon(Icons.category, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Type: ${order.itemType}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        ),
        ListTile(
          leading: Icon(Icons.info, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Item ID: ${order.itemID}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        ),
        ListTile(
          leading: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Item: ${order.itemName}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        ),
        ListTile(
          leading: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Order Date: ${order.orderDate}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)), // Corrected to orderDate
        ),
        ListTile(
          leading: Icon(Icons.schedule, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Order Date: ${order.deliveryDate}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)), // Corrected to orderDate
        ),
        ListTile(
          leading: Icon(Icons.delivery_dining, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Quantity: ${order.quantity.toString()}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)), // You might want to replace productID with the actual delivery status field
        ),
        ListTile(
          leading: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Unit Price: \$${order.unitPrice.toStringAsFixed(2).toString()}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)), // Corrected to totalPrice
        ),
        ListTile(
          leading: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Total Amount: \$${order.totalPrice.toStringAsFixed(2).toString()}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)), // Corrected to totalPrice
        ),

        ListTile(
          leading: Icon(Icons.shopping_bag, color: Theme.of(context).colorScheme.onSurface,),
          title: Text('Status: ${order.status}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)), // You might want to replace totalPrice with the actual supplier name field
        ),
      ],
    );
  }
}
