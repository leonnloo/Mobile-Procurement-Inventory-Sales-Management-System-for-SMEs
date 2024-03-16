// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/login_content.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/password_field.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key, required this.email});
  final TextEditingController _passwordController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final String email;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Change Password'),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.8,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),
                  PasswordTextField(controller: _passwordController, labelText: 'Reset Password'),
                  const SizedBox(height: 16.0),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: const RoundedRectangleBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 15.0)
                        ),
                        onPressed: () async {
                          String? password = validateTextField(_passwordController.text);
                          if (password == null) {
                            formKey.currentState?.validate();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a new password.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {                
                            final response = await requestUtil.updateUserPassword(
                              email, password
                            );
                            
                            if (response.statusCode == 200) {
                              Get.to(() => LoginContent());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password updated successfully.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              // Display an error message to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(jsonDecode(response.body)['detail']),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('DONE')
                      ),
                    ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}