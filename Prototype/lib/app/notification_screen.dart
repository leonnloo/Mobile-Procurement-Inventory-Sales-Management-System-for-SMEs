import 'package:flutter/material.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Notifications'),
      body: Column(
        children: [
        ],
      ),
    );
  }
}