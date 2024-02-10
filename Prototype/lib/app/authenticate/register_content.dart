import 'package:flutter/material.dart';
import 'package:prototype/app/authenticate/login_content.dart';
import 'package:prototype/app/home/home.dart';

class RegisterContent extends StatefulWidget {
  @override
  _RegisterContentState createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final String _selectedCountryCode = '+1'; // Default country code

  // TO DO: add in a table in mongodb for a list of country codes
  final List<String> _countryCodes = [
    '+1', '+44', '+91', // Add more country codes as needed
  ];

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.04,),
                /*------ LABEL ------*/
                Image(
                  image: const AssetImage('images/register.jpg'),
                  height: size.height * 0.2,
                ),
                Text('Your ultimate inventory management solution. ', style: Theme.of(context).textTheme.headlineSmall),
                // Text('We\'re delighted to have you on board! Get ready to streamline your business operations effortlessly.', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 25.0,),
                /*------ FORM ------*/
                _RegisterForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Form _RegisterForm(context) {
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
          ElevatedButton(
            onPressed: () {
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
                print(_phoneNumberController.text);
              } else {
                // All fields are filled, proceed with registration logic
                String username = _usernameController.text;
                String email = _emailController.text;
                String phoneNumber = _phoneNumberController.text;
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (password == confirmPassword){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password does not match.'),
                      backgroundColor: Colors.red,
                    )
                  );
                } else {
                  // Add logic for registering
                  print('Register successful!');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              }
            },
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 6.0),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginContent()),
                );
              },
              child: const Text('Already have an account? Login'),
            ),
          ),
        ],
      )
    );
  }

}

