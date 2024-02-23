import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 25.0, 
              fontWeight: FontWeight.bold, 
              letterSpacing: 2.0
            ),
          ),
          
      ),
      body: Column(
        children: [
          Divider(),
        ],
      ),
    );
  }
}