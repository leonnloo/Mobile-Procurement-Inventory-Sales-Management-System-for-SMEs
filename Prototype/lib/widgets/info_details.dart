import 'package:flutter/material.dart';

Widget buildDetailRow(String label, String value, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1, // Give equal space for label, adjust based on your UI
          child: Text(
            '$label: ',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        const SizedBox(width: 8,),
        Expanded(
          flex: 2, // Adjust flex to give more space for the value
          child: Text(
            value,
            style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface),
            softWrap: true, // Allows text wrapping
          ),
        ),
      ],
    ),
  );
}