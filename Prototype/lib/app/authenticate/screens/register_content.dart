import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/forget_password/register/otp_register.dart';
import 'package:prototype/app/authenticate/screens/login_content.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/fade_in_animation/animation_design.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';
import 'package:prototype/widgets/forms/password_field.dart';

class RegisterContent extends StatefulWidget {

  const RegisterContent({super.key});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(FadeInController());
    controller.startAnimation();

    return Scaffold(
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
                      image: const AssetImage('assets/images/register.jpg'),
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
    );
  }

  Form _registerForm(context) {
    final controller = Get.put(FadeInController());
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: 'Full Name',
              hintText: 'Full Name',
              border: OutlineInputBorder()
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email',
              hintText: 'Email',
              border: OutlineInputBorder()
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          PasswordTextField(controller: _passwordController, labelText: 'Password'),
          const SizedBox(height: 16.0),
          PasswordTextField(controller: _confirmPasswordController, labelText: 'Confirm Password'),
          const SizedBox(height: 16.0),
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
              onPressed: () async {
                String? usernameError = validateTextField(_usernameController.text);
                String? emailError = validateTextField(_emailController.text);
                String? phoneNumberError = validateTextField(_phoneNumberController.text);
                String? passwordError = validateTextField(_passwordController.text);
                String? confirmPasswordError = validateTextField(_confirmPasswordController.text);
            
                if (usernameError == null ||
                    emailError == null ||
                    phoneNumberError == null ||
                    passwordError == null ||
                    confirmPasswordError == null) {
                  _formKey.currentState?.validate();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please fill in all the required fields.'),
                      backgroundColor: Theme.of(context).colorScheme.error,
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
                    final response = await requestUtil.sendVerificationEmail(email);
                    if (response.statusCode == 200){
                      Get.to(() => OTPRegisterScreen(email: email, password: password, username: username, phoneNumber: phoneNumber));
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
                        content: const Text('Password does not match.'),
                        backgroundColor: Theme.of(context).colorScheme.error,
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
                  MaterialPageRoute(builder: (context) => const LoginContent()),
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

