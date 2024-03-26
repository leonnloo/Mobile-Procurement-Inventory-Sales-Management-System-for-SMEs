import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropdownTextField extends StatefulWidget {
  final String labelText;
  late Future<List<String>> options;
  final ValueChanged<String?> onChanged;
  final dynamic data;
  bool defaultSelected = false;
  DropdownTextField({super.key, 
    required this.labelText,
    required this.options,
    required this.onChanged,
    required this.defaultSelected,
    this.data
  });

  @override
  DropdownTextFieldState createState() => DropdownTextFieldState();
}

class DropdownTextFieldState extends State<DropdownTextField> {
  String? selectedValue;
  bool activated = true;
  String defaultValue = '';


  @override
  Widget build(BuildContext context) {
    return widget.defaultSelected ? dropDownTextFilled(context) : dropDownTextEmpty(context) ;
  }

// ! change to stream builder
  Widget dropDownTextEmpty(BuildContext context) {
    final noOptionText = '${widget.labelText} not available';
    return FutureBuilder<List<String>>(
      future: widget.options,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); 
        } else if (snapshot.hasError) {
          return Text('Error loading options: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return DropdownButtonFormField<String>(
            value: defaultValue,
            items: snapshot.data!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.onChanged(newValue);
                defaultValue = newValue;
              }
            },
            decoration: InputDecoration(
              labelText: noOptionText,
              border: const OutlineInputBorder(),
            ),
          );
        } else {
          return DropdownButtonFormField<String>(
            items: snapshot.data!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.onChanged(newValue);
              }
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }
  
  Widget dropDownTextFilled(BuildContext context) {
    final noOptionText = '${widget.labelText} not available';
    return FutureBuilder<List<String>>(
      future: widget.options,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text('Error loading options: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return DropdownButtonFormField<String>(
            value: defaultValue,
            items: snapshot.data!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.onChanged(newValue);
                defaultValue = newValue;
              }
            },
            decoration: InputDecoration(
              labelText: noOptionText,
              border: const OutlineInputBorder(),
            ),
          );
        } else {
          List<String> dropdownItems = snapshot.data!;
          if (activated) {
            if (widget.data != null) {
              int dataIndex = dropdownItems.indexOf(widget.data!);
              defaultValue = dataIndex != -1 ? widget.data! : dropdownItems.first;
            } else {
              defaultValue = dropdownItems.isNotEmpty ? dropdownItems.first : '';
            }
            activated = false;
          }

          return DropdownButtonFormField<String>(
            value: defaultValue,
            items: snapshot.data!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.onChanged(newValue);
                defaultValue = newValue;
              }
            },
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }
}
