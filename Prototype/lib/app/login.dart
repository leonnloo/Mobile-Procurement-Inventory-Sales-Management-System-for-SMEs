import 'package:flutter/material.dart';
import 'package:prototype/app/screenmanager.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// login page
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Inventory Management System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your company's logo here
            Image.asset(
              'images/nottingham.jpg', // Replace with the path to your logo asset
              height: 100, // Adjust the height as needed
            ),
            SizedBox(height: 76.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Add your authentication logic here
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Example: Check if username and password are not empty
                if (username.isNotEmpty && password.isNotEmpty) {
                  // Add your authentication logic here
                  // For simplicity, let's print a message
                  print('Login successful!');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenManager()),
                  );
                } else {
                  // Show an error message or handle the case where
                  // username or password is empty
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenManager()),
                  );
                  print('Please enter both username and password');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
