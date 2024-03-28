// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/login_content.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

class OTPRegisterScreen extends StatelessWidget {
  OTPRegisterScreen({super.key, required this.email, required this.password, required this.username, required this.phoneNumber});
  final RequestUtil requestUtil = RequestUtil();
  final String email;
  final String password;
  final String username;
  final String phoneNumber;
  final controller = Get.put(FadeInController());

  @override
  Widget build(BuildContext context) {
    String globalCode = '';
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('VERIFY EMAIL', style: Theme.of(context).textTheme.headlineLarge,),
            Text('Enter the verification code sent to your email.', style: Theme.of(context).textTheme.bodyLarge,),
            const SizedBox(height: 40.0,),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) { globalCode = code;}
            ),
            const SizedBox(height: 40.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  side: const BorderSide(color: Colors.black),
                  shape: const RoundedRectangleBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 15.0)
                ),
                onPressed: () async {
                  final response = await requestUtil.verifyUser(email, globalCode);
                  if (response.statusCode == 200){
                    final register = await requestUtil.createUser(
                      username, email, phoneNumber, password
                    );
                    if (register.statusCode == 200) {
                      controller.resetAnimation();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginContent()),
                      );
                      Get.to(() => LoginContent());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(jsonDecode(register.body)['detail']),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(jsonDecode(response.body)['detail']),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      )
                    );
                  }
                }, 
                child: const Text('Next')),
            )
          ],
        ),
      ),
    );
  }
}