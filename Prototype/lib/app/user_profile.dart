import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/start_screen.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
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
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: size.height * 0.13,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('images/nottingham.jpg'),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Notts',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'notts@nottingham.edu.cn',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
          const SizedBox(height: 16.0),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Role'),
            subtitle: Text('Manager'), // Replace with the user's phone number
          ),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone Number'),
            subtitle: Text('+123 456 7890'), // Replace with the user's phone number
          ),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            subtitle: Text('Ningbo, China'), // Replace with the user's location
          ),
          // Add more ListTile widgets for additional user details

          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle the edit functionality here
                // You can navigate to an edit screen or show a dialog for editing
                // For now, let's print a message
                print('Edit button pressed');
              },
              style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: const RoundedRectangleBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 10.0)
                          ),
              child: const Text('Edit', style: TextStyle(fontSize: 16.0),),
            ),
          ),
        ],
      ),
    );
  }
}
