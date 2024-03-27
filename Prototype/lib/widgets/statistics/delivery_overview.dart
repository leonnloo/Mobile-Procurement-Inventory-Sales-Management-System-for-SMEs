import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';
import 'package:prototype/util/get_controllers/procurement_controller.dart';

// ignore: must_be_immutable
class DeliveryOverview extends StatelessWidget {
  DeliveryOverview({super.key,});
  final orderController = Get.put(OrderController());
  final purchaseController = Get.put(PurchaseController());
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
            child: Row(
              children: [
                Text(
                  'Delivery',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(width: 14.0,),
                Icon(Icons.local_shipping, color: Theme.of(context).colorScheme.onSurface, size: 30,),
              ],
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
                          future: purchaseController.getPurchases('all'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: null, // null indicates an indeterminate progress which spins
                                    strokeWidth: 4.0, // Thickness of the circle line
                                    backgroundColor: Colors.transparent, // Color of the background circle
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
                          future: orderController.getOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: null, // null indicates an indeterminate progress which spins
                                    strokeWidth: 4.0, // Thickness of the circle line
                                    backgroundColor: Colors.transparent, // Color of the background circle
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