import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/user_profile.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  HeaderDrawerState createState() => HeaderDrawerState();
}

class HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(const UserProfileScreen());
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
            const Text(           
              "Notts",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              "notts@nottingham.edu.cn",
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
}