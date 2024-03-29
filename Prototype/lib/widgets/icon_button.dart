import 'package:flutter/material.dart';

Widget buildButtonWithIcon({required VoidCallback onPressed, required IconData icon, required String label, required BuildContext context}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 30.0, color: Theme.of(context).colorScheme.surface,),
    label: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        label,
        style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.surface), 
      ),
    ),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      padding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}