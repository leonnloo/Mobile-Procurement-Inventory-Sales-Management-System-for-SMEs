import 'package:flutter/material.dart';


class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const PasswordTextField({super.key, required this.controller, required this.labelText});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  var obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.vpn_key_outlined),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          const label = 'password';
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}