import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/get_refunds.dart';
import 'package:prototype/models/order_model.dart';

// ignore: must_be_immutable
class OrderDropdownTextField extends StatefulWidget {
  final String labelText;
  late Future<List<SalesOrder>> options;
  final ValueChanged<SalesOrder?> onChanged;
  OrderDropdownTextField({super.key, 
    required this.labelText,
    required this.options,
    required this.onChanged,
  });

  @override
  OrderDropdownTextFieldState createState() => OrderDropdownTextFieldState();
}

class OrderDropdownTextFieldState extends State<OrderDropdownTextField> {
  String? selectedValue;
  SalesOrder? selectedOrder;


  @override
  Widget build(BuildContext context) {
    final noOptionText = '${widget.labelText} not available';
    return FutureBuilder<List<SalesOrder>>(
      future: widget.options,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 45,
          ); 
        } else if (snapshot.hasError) {
          return Text('Error loading options: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return DropdownButtonFormField<SalesOrder>(
            items: snapshot.data!.map((SalesOrder order) {
              return DropdownMenuItem<SalesOrder>(
                value: order,
                child: Text(order.orderID),
              );
            }).toList(),
            onChanged: (SalesOrder? newValue) {
              if (newValue != null) {
                selectedOrder = newValue;
                widget.onChanged(newValue);
              }
            },
            decoration: InputDecoration(
              labelText: noOptionText,
              border: const OutlineInputBorder(),
            ),
          );
        } else {
          return DropdownButtonFormField<SalesOrder?>(
            items: snapshot.data!
                .where((SalesOrder order) => order.orderStatus != "Refunded") // Filtering condition
                .map<DropdownMenuItem<SalesOrder>>((SalesOrder order) {
              return DropdownMenuItem<SalesOrder>(
                value: order,
                child: Text(order.orderID),
              );
            }).toList(),
            onChanged: (SalesOrder? newValue) {
              if (newValue != null) {
                selectedOrder = newValue;
                widget.onChanged(newValue);
              }
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }
}
