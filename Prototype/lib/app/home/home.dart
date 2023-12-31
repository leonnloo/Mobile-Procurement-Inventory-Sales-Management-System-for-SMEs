import 'package:flutter/material.dart';
import 'package:prototype/app/userprofile.dart';
import 'package:prototype/widgets/bottomnavigator.dart';
import 'package:prototype/widgets/totalprofits.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GRP Team-14'), // company name
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: 
      Column(
        children: [
          Expanded(
            // child: Text("data"),
            child: TotalProfitsScreen(),
          ),
        ],
      ),
        // TotalProfitsScreen(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}