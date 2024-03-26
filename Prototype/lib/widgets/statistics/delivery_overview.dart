import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/sales_management/Claims_and_Refunds/get_refunds.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/models/procurement_model.dart';

class DeliveryOverview extends StatelessWidget {
  DeliveryOverview({super.key,});

  int ingoing = 0;
  int outgoing = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Delivery',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Incoming',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: _fetchProcurementList(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: null, // null indicates an indeterminate progress which spins
                                    strokeWidth: 4.0, // Thickness of the circle line
                                    backgroundColor: Colors.grey[200], // Color of the background circle
                                    color: Theme.of(context).colorScheme.onSurface, // Color of the progress indicator
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData) {
                              return SizedBox(
                                height: 150.0,
                                child: Center(
                                  child: Text('Unable to load', style: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.onSurface),),
                                ),
                              );
                            } else {
                              List<PurchasingOrder> purchases = snapshot.data!;
                              calculateIngoing(purchases);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(ingoing.toString(), style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.onSurface),),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0,),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Outgoing',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: getOrderList(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: null, // null indicates an indeterminate progress which spins
                                    strokeWidth: 4.0, // Thickness of the circle line
                                    backgroundColor: Colors.grey[200], // Color of the background circle
                                    color: Theme.of(context).colorScheme.onSurface, // Color of the progress indicator
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData) {
                              return SizedBox(
                                height: 150.0,
                                child: Center(
                                  child: Text('Unable to load', style: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.onSurface),),
                                ),
                              );
                            } else {
                              List<SalesOrder> sales = snapshot.data!;
                              calculateOutgoing(sales);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(outgoing.toString(), style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.onSurface),),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<PurchasingOrder>> _fetchProcurementList() async {
    final procurement = await requestUtil.getProcurement();
    if (procurement.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(procurement.body);
      List<PurchasingOrder> procurementList = jsonData.map((data) => PurchasingOrder.fromJson(data)).toList();
      return procurementList;
    } else {
      throw Exception('Unable to fetch procurement data.');
    }
  }
  
  void calculateOutgoing(List<SalesOrder> sales) {
    for (var sale in sales){
      if (sale.completionStatus == 'To be Delivered'){
        outgoing++;
      }
    }
  }
  
  void calculateIngoing(List<PurchasingOrder> purchase) {
    for (var pur in purchase){
      if (pur.status == 'Delivering'){
        ingoing++;
      }
    }
  }
}