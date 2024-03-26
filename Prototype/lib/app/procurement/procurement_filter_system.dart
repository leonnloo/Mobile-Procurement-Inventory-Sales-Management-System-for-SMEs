// main.dart
import 'package:flutter/material.dart';
import 'package:prototype/models/procurement_model.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';

class FilterSystem extends StatefulWidget {
  const FilterSystem({super.key});
  @override State<StatefulWidget> createState() => FilterSystemState();
}
class FilterSystemState extends State<FilterSystem>{

  TextEditingController searchController = TextEditingController();
  // static List<PurchasingOrder> searchList = pastOrders + presentOrders;
  static List<PurchasingOrder> searchList = [];

  // List<PurchasingOrder> displayList = List.from(searchList);
  List<PurchasingOrder> displayList = [];

  void updateList(String value){
    displayList = searchList
      .where((element) => element.purchaseID.toLowerCase().contains(value.toLowerCase()))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Purchasing records'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => updateList(value)),
              decoration: InputDecoration(
                filled: true,
                // fillColor: ,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none
                ),
                hintText: 'Enter order number here',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10.0,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        '${displayList[index].purchaseID} ${displayList[index].status}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('${displayList[index].orderDate} to ${displayList[index].deliveryDate}', style: TextStyle(color: Theme.of(context).colorScheme.error),),
                      
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}