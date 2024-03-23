import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntegerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueChanged<String> onChanged;
  final bool floatData;
  const IntegerTextField({
    super.key, 
    required this.controller, 
    required this.labelText, 
    required this.onChanged,
    required this.floatData,
  });

  @override
  Widget build(BuildContext context) {
    return floatData ? floatTextEditingController() : integerTextField();
  }

  Widget floatTextEditingController() {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          RegExp(r'^\d+\.?\d{0,2}$'),
        ),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        if (newValue != null) {
          // String formattedValue = double.parse(newValue).toStringAsFixed(2);
          // onChanged(formattedValue);
          onChanged(newValue);
        }
      },
    );
  }
  Widget integerTextField() {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}