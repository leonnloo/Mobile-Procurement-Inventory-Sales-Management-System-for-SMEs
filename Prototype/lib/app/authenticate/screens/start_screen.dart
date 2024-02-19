import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/widgets/fade_in_animation/animation_design.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';
import 'login_content.dart';
import 'register_content.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  final String login = 'Login';
  final String signup = 'Sign Up';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(FadeInController());
    controller.startAnimation();

    return Scaffold(
      body: Stack(
        children: [
          FadeInAnimation(
            durantionInMs: 2000,
            animate: AnimatePosition(
              bottomAfter: 0,
              bottomBefore: -100,
              topAfter: 0,
              topBefore: 0,
              rightAfter: 0,
              rightBefore: 0,
              leftAfter: 0,
              leftBefore: 0
            ),
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add your company's logo here
                  Image.asset(
                    'images/nottingham.jpg', // Replace with the path to your logo asset
                    height: size.height * 0.15, // Adjust the height as needed
                  ),
                  const SizedBox(height: 76.0),
                  Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.resetAnimation();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginContent()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                padding: const EdgeInsets.symmetric(vertical: 15.0)
                              ),
                              child: Text(login.toUpperCase()),
                            ),
                          ),
                          const SizedBox(width: 35.0,),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                controller.resetAnimation();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterContent()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 15.0)
                              ),
                              child: Text(signup.toUpperCase()),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
