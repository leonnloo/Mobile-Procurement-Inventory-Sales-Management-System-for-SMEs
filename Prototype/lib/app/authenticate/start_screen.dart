import 'package:flutter/material.dart';
import 'login_content.dart';
import 'register_content.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final String login = 'Login';
  final String signup = 'Sign Up';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your company's logo here
            Image.asset(
              'images/nottingham.jpg', // Replace with the path to your logo asset
              height: 100, // Adjust the height as needed
            ),
            SizedBox(height: 76.0),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginContent()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 15.0)
                        ),
                        child: Text(login.toUpperCase()),
                      ),
                    ),
                    SizedBox(width: 35.0,),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterContent()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(),
                          padding: EdgeInsets.symmetric(vertical: 15.0)
                        ),
                        child: Text(signup.toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
