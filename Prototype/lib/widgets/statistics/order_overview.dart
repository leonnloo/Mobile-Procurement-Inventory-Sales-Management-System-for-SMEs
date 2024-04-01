// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/order_model.dart';
import 'package:prototype/util/get_controllers/order_controller.dart';

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        // color: const Color.fromARGB(255, 252, 215, 252),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        color: Theme.of(context).colorScheme.onPrimary,
        elevation: 4.0,
        // color: const Color.fromARGB(255, 11, 238, 181),
        margin: const EdgeInsets.all(16.0),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Order Overview',
                        style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 5,),
                OrderCount(),
              ],
            ),
          ),
      ),
    );
  }
}

class OrderCount extends StatelessWidget {
  OrderCount({super.key,});

  int tbp = 0;
  int tbd = 0;
  int tbs = 0;
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          List<SalesOrder> orders = snapshot.data!;
          calculateStock(orders);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCol('$tbp', 'To be Packaged', context),
              _buildCol('$tbs', 'To be Shipped', context),
              _buildCol('$tbd', 'To be Delivered', context),
            ],
          );
        }
      }
    );
  }

  Widget _buildCol(String count, String label, BuildContext context) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count, 
          style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.onSurface),
          textAlign: TextAlign.center, // Center align text
        ),
        const SizedBox(height: 4), // Optional: add some spacing between the number and label
        Text(
          label, 
          style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.onSurface),
          textAlign: TextAlign.center, // Center align text
        ),
      ],
    ),
  );
}

  
  void calculateStock(List<SalesOrder> orders) {
    for (var order in orders) {
      if (order.completionStatus == 'To be Packaged') {
        tbp++;
      } else if (order.completionStatus == 'To be Shipped') {
        tbs++;
      } else if (order.completionStatus == 'To be Delivered'){
        tbd++;
      }
    }
  }
}
