import 'package:flutter/material.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  // Change super.key to Key? key
  ForgetPasswordMailScreen({Key? key}) : super(key: key);

  final TextEditingController _forgetEmailController = TextEditingController();
  String? _validateTextField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Reset Password by Mail',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: _forgetEmailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30.0),
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
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
