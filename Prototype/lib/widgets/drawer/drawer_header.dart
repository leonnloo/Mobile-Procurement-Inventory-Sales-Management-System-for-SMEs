import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/user_profile.dart';
import 'package:prototype/util/user_controller.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  HeaderDrawerState createState() => HeaderDrawerState();
}

class HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 240,
            width: double.infinity,
            color: Colors.red[400],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 26.0),
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.red,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
                color: Colors.red[400],
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TO DO: user information
                    Text(           
                      "Unable to load user data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              );
        } else {
          final user = snapshot.data;
          if (user != null) {
            return GestureDetector(
              onTap: () {
                Get.to(() => const UserProfileScreen());
              },
              child: Container(
                color: Colors.red[400],
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/nottingham.jpg'),
                        ),
                      ),
                    ),
                    // TO DO: user information
                    Text(           
                      user['employee_name'],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      user["email"],
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return Container(
                color: Colors.red[400],
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.only(top: 20.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TO DO: user information
                    Text(           
                      "Unable to load user data",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
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
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }
}