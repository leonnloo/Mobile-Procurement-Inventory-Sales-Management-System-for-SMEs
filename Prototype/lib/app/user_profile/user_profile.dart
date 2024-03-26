import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/start_screen.dart';
import 'package:prototype/app/user_profile/edit_user.dart';
import 'package:prototype/models/user_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/user_controller.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

final RequestUtil requestUtil = RequestUtil();
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final userController = Get.put(UserLoggedInController());
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInController());
    final size = MediaQuery.of(context).size;
    final user = userController.currentUserInfo.value!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.red[400],
        actions: [
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.logout),
            onPressed: () {
              controller.resetAnimation();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 40.0),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: size.height * 0.13,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/nottingham.jpg'),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            userController.currentUserInfo.value!.employeeName,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            user.email,
            style: const TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
          const SizedBox(height: 16.0),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Role'),
            subtitle: Text(user.role),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Number'),
            subtitle: Text(user.phoneNumber),
          ),

    
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => EditUser(updateData: updateData));
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                side: const BorderSide(color: Colors.black),
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(vertical: 15.0)
              ),
              child: const Text('Edit', style: TextStyle(fontSize: 16.0),),
            ),
          ),
        ],
      ),
    );
  }

  void updateData() async {
    setState(() {
    });
  }
}
