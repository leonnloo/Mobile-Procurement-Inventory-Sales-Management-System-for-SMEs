import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/start_screen.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/user_controller.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

final RequestUtil requestUtil = RequestUtil();
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInController());
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or a loading indicator
        } else if (snapshot.hasError) {
          print('object');
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data;
          print("HEY");
          if (user != null) {
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
                  Text(
                    user['employee_name'],
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    user['email'],
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Role'),
                    subtitle: Text(user['role'] ?? 'No role'), // Replace with the user's phone number
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone Number'),
                    subtitle: Text(user['phone_number']), // Replace with the user's phone number
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.location_on),
                  //   title: const Text('Location'),
                  //   subtitle: Text(user['email']), // Replace with the user's location
                  // ),
                  // Add more ListTile widgets for additional user details
            
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the edit functionality here
                        // You can navigate to an edit screen or show a dialog for editing
                        // For now, let's print a message
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
          else {
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
              body: const Text("Error while retrieving user data.")
            );
          }
        }
      }
    );
  }


  Future<Map<String, dynamic>> _fetchUserData() async {
    final userController = Get.put(UserLoggedInController());
    try {
      // print(userController.currentUser.value);
      final user = await requestUtil.getUser(userController.currentUser.value);
      return jsonDecode(user.body);
      // final tokenResponse = await requestUtil.getToken(userController.currentUser.value);

      // if (tokenResponse == null || tokenResponse.body == null) {
      //   throw Exception('Token response is null or missing body.');
      // }

      // final tokenData = jsonDecode(tokenResponse.body);
      // if (tokenData == null || tokenData['access_token'] == null) {
      //   throw Exception('Access token is null or missing.');
      // }

      // final user = requestUtil.getUser(tokenData['access_token']);

      // return {'token': tokenData['access_token'], 'user': user};
    } catch (error) {
      // print('Error in _fetchUserData: $error');
      throw error; // Rethrow the error to be caught by FutureBuilder
    }
  }


}
