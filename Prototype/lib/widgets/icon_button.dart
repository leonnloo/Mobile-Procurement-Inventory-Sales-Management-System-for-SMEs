import 'package:flutter/material.dart';

Widget buildButtonWithIcon({required VoidCallback onPressed, required IconData icon, required String label}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 30.0),
    label: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18.0),
      ),
    ),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, backgroundColor: Colors.white,
      padding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}