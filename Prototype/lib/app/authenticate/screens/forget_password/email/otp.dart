import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/forget_password/email/reset_password.dart';
import 'package:prototype/util/request_util.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key, required this.email});
  final RequestUtil requestUtil = RequestUtil();
  final String email;

  @override
  Widget build(BuildContext context) {
    String globalCode = '';
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('RESET PASSWORD', style: Theme.of(context).textTheme.headlineLarge,),
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
                    Get.to(() => ResetPassword(email: email,));
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(jsonDecode(response.body)['detail']),
                        backgroundColor: Colors.red,
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