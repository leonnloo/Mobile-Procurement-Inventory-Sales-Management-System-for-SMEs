import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/inventorydata.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  HomeSearchState createState() => HomeSearchState();
}

class HomeSearchState extends State<HomeSearch>{

  TextEditingController searchController = TextEditingController();
  static List<InventoryItem> searchList = inventoryItems; 
  List<InventoryItem> displayList = List.from(searchList);

  void updateList(String value){
    displayList = searchList
      .where((element) => element.itemName.toLowerCase().contains(value.toLowerCase()))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                hintText: 'Search',
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
                        displayList[index].itemName,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(displayList[index].category),
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
