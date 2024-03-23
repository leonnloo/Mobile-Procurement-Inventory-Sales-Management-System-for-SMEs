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
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInController());
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data;
          if (user != null) {
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
                    subtitle: Text(user['role'] ?? 'No role'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone Number'),
                    subtitle: Text(user['phone_number']),
                  ),

            
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        User userEdit = User(employeeName: user['employee_name'], employeeID: user['employee_id'], email: user['email'], password: user['password'], phoneNumber: user['phone_number'], role: user['role'] ?? 'No Role', salesRecord: user['sales_record'] ?? []);
                        Get.to(() => EditUser(user: userEdit, updateData: updateData));
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
      final user = await requestUtil.getUser(userController.currentUser.value);
      if (user.statusCode == 200){
        return jsonDecode(user.body);
      }
      else {
        throw Exception('Unable to fetch user data.');
      }
    } catch (error) {
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Set the color of the loading indicator
            ),
            SizedBox(height: 16.0),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}
