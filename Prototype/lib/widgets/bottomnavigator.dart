import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  int currentIndex;
  final Function(int) onIndexChanged;

  CustomBottomNavigationBar({required this.currentIndex, required this.onIndexChanged});
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return 
      BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
          widget.onIndexChanged(index); // Callback to notify ScreenManager
        },
        backgroundColor: Color.fromARGB(255, 255, 16, 16),
        selectedItemColor: Color.fromARGB(255, 255, 0, 0),
        unselectedItemColor: Color.fromARGB(255, 6, 3, 3),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Procurement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Supplier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customer',
          ),
        ],
      );
  }
}
