// main_view.dart

import 'package:flutter/material.dart';
import 'login.dart'; // Import the login screen
import 'home/home.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GRP-Team 14',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomeScreen(),
      home: LoginScreen(),
    );
  }
}
