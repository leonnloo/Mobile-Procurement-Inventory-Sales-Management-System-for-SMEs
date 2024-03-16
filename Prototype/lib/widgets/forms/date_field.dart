import 'package:flutter/material.dart';

class BuildDateField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final dynamic data;
  
  const BuildDateField({super.key, required this.controller, required this.labelText, this.data});

  @override
  BuildDateFieldState createState() => BuildDateFieldState();
}

class BuildDateFieldState extends State<BuildDateField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _selectDate(context);
      },
      child: AbsorbPointer(
        absorbing: true, // Disable interactions
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.labelText,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              final label = widget.labelText.toLowerCase();
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        widget.controller.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
}
