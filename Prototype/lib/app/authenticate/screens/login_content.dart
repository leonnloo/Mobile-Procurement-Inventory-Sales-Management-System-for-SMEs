import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/forget_password/option/forget_password_option.dart';
import 'package:prototype/app/authenticate/screens/register_content.dart';
import 'package:prototype/app/home/home.dart';
import 'package:prototype/widgets/fade_in_animation/animation_design.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

class LoginContent extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginContent({super.key});

  String? _validateTextField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(FadeInController());
    controller.startAnimation();

    return SafeArea(
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
                        'images/login.jpg',
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
    final controller = Get.put(FadeInController());
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: 'Email',
              hintText: 'Email',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.vpn_key_outlined),
              labelText: 'Password',
              hintText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.remove_red_eye_rounded)
            ),
          ),
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
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: const RoundedRectangleBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 15.0)
                          ),
              onPressed: () {
                // Add your authentication logic here
                String? emailError = _validateTextField(_emailController.text, 'Email');
                String? passwordError = _validateTextField(_passwordController.text, 'Password');
                // Add logic for logging in
                if (emailError != null || passwordError != null) {
                    // Display validation error messages
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all the required fields.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                  } else {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    // TO DO: compare email and password to the ones in the database
                    print(email);
                    print(password);
                    // if (emailError == null || passwordError == null){
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Email or password is incorrect.'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    // } else {
                      // Add logic for login
                      print('Login successful!');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    // }
                  }
              },
              child: const Text('LOGIN'),
            ),
          ),
          const SizedBox(height: 6.0),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                controller.resetAnimation();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterContent()),
                );
              },
              child: const Text('Don\'t have an account? SIGN UP'),
            ),
          ),
        ],
      )
    );
  }

  
}
