import 'package:flutter/material.dart';
import 'package:prototype/models/inventorydata.dart';

class InventoryOverview extends StatefulWidget {
  const InventoryOverview({
    super.key,
  }); 

  @override
  InventoryOverviewState createState() => InventoryOverviewState();
}

class InventoryOverviewState extends State<InventoryOverview>{
  List<InventoryItem> displayedInventoryItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Inventory'),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initially, display all inventory items
    displayedInventoryItems = List.from(inventoryItems);
  }

  void filterInventoryItems(String query) {
    setState(() {
      displayedInventoryItems = inventoryItems
          .where((item) => item.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}