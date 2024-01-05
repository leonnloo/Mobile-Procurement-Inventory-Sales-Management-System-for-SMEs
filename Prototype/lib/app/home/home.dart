import 'package:flutter/material.dart';
import 'package:prototype/app/userprofile.dart';
import 'package:prototype/widgets/totalprofits.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int index) onWidgetClick; // Add this line

  HomeScreen({required this.onWidgetClick}); // Add this constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TotalProfitsScreen(
              onWidgetsClick: (index) {
                widget.onWidgetClick(index);
              },
            ),
          ),
        ],
      ),
    );
  }



}
