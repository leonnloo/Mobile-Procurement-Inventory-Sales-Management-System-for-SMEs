import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/login_content.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/widgets/fade_in_animation/animation_design.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

class RegisterContent extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // final String _selectedCountryCode = '+1'; // Default country code

  // // TO DO: add in a table in mongodb for a list of country codes
  // final List<String> _countryCodes = [
  //   '+1', '+44', '+91', // Add more country codes as needed
  // ];

  RegisterContent({super.key});

  String? _validateTextField(String value, String fieldName) {
    if (value.isEmpty) {
      return null;
    }
    return value;
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
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.03,),
                      /*------ LABEL ------*/
                      Image(
                        image: const AssetImage('images/register.jpg'),
                        height: size.height * 0.2,
                      ),
                      Text('Your ultimate inventory management solution. ', style: Theme.of(context).textTheme.headlineSmall),
                      // Text('We\'re delighted to have you on board! Get ready to streamline your business operations effortlessly.', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 25.0,),
                      /*------ FORM ------*/
                      _registerForm(context),
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
  Form _registerForm(context) {
    final RequestUtil requestUtil = RequestUtil();
    final controller = Get.put(FadeInController());
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: 'Full Name',
              hintText: 'Full Name',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email',
              hintText: 'Email',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              /* ------- EXTRA TO DO: COUNTRY CODES -------*/
              // prefix: DropdownButton<String>(
              //   value: _selectedCountryCode,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _selectedCountryCode = newValue!;
              //     });
              //   },
              //   items: _countryCodes.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),
              /* ----------------------------------------- */

              prefixIcon: Icon(Icons.phone_outlined),
              labelText: 'Phone Number',
              hintText: 'Phone Number',
              border: OutlineInputBorder(),
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
          const SizedBox(height: 16.0),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.vpn_key_outlined),
              labelText: 'Confirm Password',
              hintText: 'Confirm Password',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.remove_red_eye_rounded)
            ),
          ),
          const SizedBox(height: 16.0),
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
              onPressed: () async {
                // Add your authentication logic here
                String? usernameError = _validateTextField(_usernameController.text, 'Full Name');
                String? emailError = _validateTextField(_emailController.text, 'Email');
                String? phoneNumberError = _validateTextField(_phoneNumberController.text, 'Phone Number');
                String? passwordError = _validateTextField(_passwordController.text, 'Password');
                String? confirmPasswordError = _validateTextField(_confirmPasswordController.text, 'Confirm Password');
            
                if (usernameError != null ||
                    emailError != null ||
                    phoneNumberError != null ||
                    passwordError != null ||
                    confirmPasswordError != null) {
                  // Display validation error messages
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the required fields.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // All fields are filled, proceed with registration logic
                  String username = _usernameController.text;
                  String email = _emailController.text;
                  String phoneNumber = _phoneNumberController.text;
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;
            
                  if (password == confirmPassword){
                    final response = await requestUtil.createUser(
                      username, email, phoneNumber, password
                    );
                    if (response.statusCode == 200) {
                      // Successful login
                      // print("Register successful!");
                      // Navigate to the home screen or perform other actions
                      controller.resetAnimation();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginContent()),
                      );
                    } else {
                      // Failed login
                      // print("Register failed");
                      // print("Error: ${response.body}");
                      
                      // Display an error message to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(jsonDecode(response.body)['detail']),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password does not match.'),
                        backgroundColor: Colors.red,
                      )
                    );
                  }
                }
              },
              child: const Text('SIGN UP'),
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
                  MaterialPageRoute(builder: (context) => LoginContent()),
                );
              },
              child: const Text('Already have an account? LOGIN'),
            ),
          ),
        ],
      )
    );
  }

}

