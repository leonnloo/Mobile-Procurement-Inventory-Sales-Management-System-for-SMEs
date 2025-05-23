// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/forget_password/email/otp.dart';
import 'package:prototype/app/authenticate/screens/forget_password/email/reset_password.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  ForgetPasswordMailScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _forgetEmailController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail, color: Theme.of(context).colorScheme.onSurface, size: 70,),
                const SizedBox(height: 20,),
                const Text(
                  'Reset Password by Mail',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Please enter your email address.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                BuildTextField(controller: _forgetEmailController, labelText: 'Email'),
                const SizedBox(height: 30.0),
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
                      String? email = validateTextField(_forgetEmailController.text);
                      if (email != null){
                        final verifyResponse = await requestUtil.verifyEmail(_forgetEmailController.text);
                            Get.to(() => ResetPassword(email: email,));
                        if (verifyResponse.statusCode == 200) {
                          final response = await requestUtil.sendVerificationEmail(email);
                          if (response.statusCode == 200){
                            Get.to(() => OTPScreen(email: email,));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Error sending verification email.'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                              )
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Email not registered.'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            )
                          );
                        }
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please enter your email address'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          )
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
