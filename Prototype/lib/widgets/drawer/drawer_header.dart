import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/user_profile/user_profile.dart';
import 'package:prototype/util/user_controller.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  HeaderDrawerState createState() => HeaderDrawerState();
}

class HeaderDrawerState extends State<HeaderDrawer> {
  final userController = Get.put(UserLoggedInController());
  @override
  Widget build(BuildContext context) {
    userController.updateDrawerFunction(updateData);
    return GestureDetector(
      onTap: () {
        Get.to(() => const UserProfileScreen());
      },
      child: Container(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                  image: AssetImage('assets/images/nottingham.jpg'),
                ),
              ),
            ),
            // TO DO: user information
            Text(           
              userController.currentUserInfo.value!.employeeName,
              style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 20),
            ),
            Text(
              userController.currentUserInfo.value!.email,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void updateData(){
    setState(() {
    });
  }

}