// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/forget_password/option/forget_password_option.dart';
import 'package:prototype/app/authenticate/screens/register_content.dart';
import 'package:prototype/app/home/home.dart';
import 'package:prototype/models/user_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/get_controllers/user_controller.dart';
import 'package:prototype/util/user_session.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/fade_in_animation/animation_design.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';
import 'package:prototype/widgets/forms/password_field.dart';
import 'package:prototype/widgets/loading_overlay.dart';

final RequestUtil requestUtil = RequestUtil();
class LoginContent extends StatefulWidget {

  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final controller = Get.put(FadeInController());
  final userController = Get.put(UserLoggedInController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    controller.startAnimation();
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            FadeInAnimation(
              durantionInMs: 1000,
              animate: AnimatePosition(
                bottomAfter: 0,
                bottomBefore: 0,
                topAfter: 0,
                topBefore: 0,
                leftAfter: 0,
                leftBefore: 0,
                rightAfter: 0,
                rightBefore: 0
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.04,),
                      /*------ LABEL ------*/
                      Image.asset(
                        'assets/images/login.jpg',
                        height: size.height * 0.2,
                      ),
                      const SizedBox(height: 25.0,),
                      Text('Welcome back to our app!', style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 25.0,),
                      /*------ FORM ------*/
                      _loginForm(context),
                      const SizedBox(height: 25.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Form _loginForm(context) {
    final fadeInController = Get.put(FadeInController());
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: 'Email / Username',
              hintText: 'Email / Username',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 16.0),
          PasswordTextField(controller: _passwordController, labelText: 'Password'),
          const SizedBox(height: 6.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ForgetPasswordScreen.forgetPasswordBottomSheet(context);
              },
              child: const Text('Forget password'),
            ),
          ),
          /*------ BUTTON ------*/
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
              onPressed: () {
                _login();
              },
              child: const Text('LOGIN'),
            ),
          ),
          const SizedBox(height: 6.0),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                fadeInController.resetAnimation();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterContent()),
                );
              },
              child: const Text('Don\'t have an account? SIGN UP'),
            ),
          ),
        ],
      )
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? emailError = validateTextField(_emailController.text);
      String? passwordError = validateTextField(_passwordController.text);
      // Add logic for logging in
      if (emailError == null || passwordError == null) {
          // Display validation error messages
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please fill in all the required fields.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          final response = await requestUtil.login(
            _emailController.text,
            _passwordController.text,
          );
          if (response.statusCode == 200) {
            userController.updateUser(_emailController.text);
            final idResponse = await requestUtil.getUserID(_emailController.text);
            if (idResponse.statusCode == 200) {
              final dynamic userID = jsonDecode(idResponse.body);
              userController.updateUserID(userID);

              final userResponse = await requestUtil.getUser(userID);
              final dynamic user = jsonDecode(userResponse.body);
              final User userModel = User.fromJson(user);
              await UserSession.saveUserSession(userID, _emailController.text);
              userController.updateUserInfo(userModel);
            }
            // Navigate to the home screen or perform other actions
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            // Display an error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Email or password is incorrect.'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unable to log in.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
