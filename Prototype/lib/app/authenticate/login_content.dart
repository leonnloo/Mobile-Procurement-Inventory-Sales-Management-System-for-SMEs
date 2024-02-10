import 'package:flutter/material.dart';
import 'package:prototype/app/authenticate/register_content.dart';
import 'package:prototype/app/home/home.dart';

class LoginContent extends StatefulWidget {
  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateTextField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04,),
                /*------ LABEL ------*/
                Image(
                  image: const AssetImage('images/login.jpg'),
                  height: size.height * 0.2,
                ),
                const SizedBox(height: 25.0,),
                Text('Welcome back to our app!', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 25.0,),
                /*------ FORM ------*/
                _LoginForm(context),
                const SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _LoginForm(context) {
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
              onPressed: () {},
              child: const Text('Forget password'),
            ),
          ),
          /*------ BUTTON ------*/
          ElevatedButton(
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
                } else {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  if (email == null || password == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email or password is incorrect.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Add logic for login
                    print('Login successful!');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                }
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 6.0),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterContent()),
                );
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ),
        ],
      )
    );
  }
}