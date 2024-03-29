import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final dynamic data;
  
  const BuildTextField({super.key, required this.controller, required this.labelText, this.data});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        labelText: labelText,
        hintText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          final label = labelText.toLowerCase();
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
