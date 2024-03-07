import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final dynamic data;
  const BuildTextField({super.key, required this.controller, required this.labelText, this.data});

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: labelText,
          border: const OutlineInputBorder(),
        ),
      );
    }
    else {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: labelText,
          border: const OutlineInputBorder(),
        ),
      );
    }
  }
}