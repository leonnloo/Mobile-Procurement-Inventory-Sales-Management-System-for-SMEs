// main.dart
import 'package:flutter/material.dart';
import 'package:prototype/models/inventory_model.dart';

class FilterSystem extends StatefulWidget {
  const FilterSystem({super.key});
  @override State<StatefulWidget> createState() => FilterSystemState();
}
class FilterSystemState extends State<FilterSystem>{

  TextEditingController searchController = TextEditingController();
  static List<InventoryItem> searchList = [];
  List<InventoryItem> displayList = List.from(searchList);

  void updateList(String value){
    displayList = searchList
      .where((element) => element.itemID.toString().toLowerCase().contains(value.toLowerCase()))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Info Record'),
      ),
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
                hintText: 'Enter ID number here',
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
                        '${displayList[index].itemID}  ${displayList[index].itemName}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Quantity:${displayList[index].quantity}     Unit price:${displayList[index].unitPrice}'),
                      
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