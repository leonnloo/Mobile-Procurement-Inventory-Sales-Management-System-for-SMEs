import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropdownTextField extends StatefulWidget {
  final String labelText;
  final Future<List<String>> options;
  final ValueChanged<String?> onChanged;
  final String? data;
  final bool defaultSelected;

  const DropdownTextField({
    super.key,
    required this.labelText,
    required this.options,
    required this.onChanged,
    this.data,
    this.defaultSelected = false,
  });

  @override
  DropdownTextFieldState createState() => DropdownTextFieldState();
}

class DropdownTextFieldState extends State<DropdownTextField> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultSelected ? widget.data : '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.options,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DropdownButtonFormField<String>(
            value: selectedValue,
            items: [selectedValue!,].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.onChanged(newValue);
                selectedValue = newValue;
              }
            },
            decoration: const InputDecoration(
              labelText: 'Loading...',
              border: OutlineInputBorder(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error loading options: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('${widget.labelText} not available');
        }
        return DropdownSearch<String>(
          popupProps: const PopupProps.menu(
            fit: FlexFit.loose,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          items: snapshot.data!,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
            widget.onChanged(newValue);
          },
          selectedItem: selectedValue,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
        );
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// // ignore: must_be_immutable
// class DropdownTextField extends StatefulWidget {
//   final String labelText;
//   late Future<List<String>> options;
//   final ValueChanged<String?> onChanged;
//   final dynamic data;
//   bool defaultSelected = false;
//   DropdownTextField({super.key, 
//     required this.labelText,
//     required this.options,
//     required this.onChanged,
//     required this.defaultSelected,
//     this.data
//   });

//   @override
//   DropdownTextFieldState createState() => DropdownTextFieldState();
// }

// class DropdownTextFieldState extends State<DropdownTextField> {
//   String? selectedValue;
//   bool activated = true;
//   String defaultValue = '';


//   @override
//   Widget build(BuildContext context) {
//     return widget.defaultSelected ? dropDownTextFilled(context) : dropDownTextEmpty(context) ;
//   }

// // ! change to stream builder
//   Widget dropDownTextEmpty(BuildContext context) {
//     final noOptionText = '${widget.labelText} not available';
//     return FutureBuilder<List<String>>(
//       future: widget.options,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return DropdownSearch<String>(
//             mode: Mode.MENU,
//             showSearchBox: true,
//             label: noOptionText,
//             items: [''],
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 widget.onChanged(newValue);
//                 defaultValue = newValue;
//               }
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error loading options: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return DropdownSearch<String>(
//             mode: Mode.MENU,
//             showSearchBox: true,
//             label: noOptionText,
//             items: [''],
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 widget.onChanged(newValue);
//                 defaultValue = newValue;
//               }
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         } else {
//           String defaultValue = widget.data != null && dropdownItems.contains(widget.data) ? widget.data : dropdownItems.first;
//           return DropdownSearch<String>(
//             mode: Mode.MENU,
//             showSearchBox: true,
//             label: widget.labelText,
//             items: snapshot.data!,
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 widget.onChanged(newValue);
//                 defaultValue = newValue;
//               }
//             },
//             selectedItem: data,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         }
//       },
//     );
//   }

//   Widget dropDownTextFilled(BuildContext context) {
//     final noOptionText = '${widget.labelText} not available';
//     return FutureBuilder<List<String>>(
//       future: widget.options,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return DropdownSearch<String>(
//             mode: Mode.MENU,
//             showSearchBox: true,
//             label: noOptionText,
//             items: [''],
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 widget.onChanged(newValue);
//                 defaultValue = newValue;
//               }
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error loading options: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return DropdownSearch<String>(
//             mode: Mode.MENU,
//             showSearchBox: true,
//             label: noOptionText,
//             items: [''],
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 widget.onChanged(newValue);
//                 defaultValue = newValue;
//               }
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         } else {
//           List<String> dropdownItems = snapshot.data!;
//           String defaultValue = widget.data != null && dropdownItems.contains(widget.data) ? widget.data : dropdownItems.first;
//           return DropdownSearch<String>(
//             mode: Mode.MENU,
//             showSearchBox: true,
//             label: widget.labelText,
//             items: snapshot.data!,
//             onChanged: (String? newValue) {
//               if (newValue != null) {
//                 widget.onChanged(newValue);
//                 defaultValue = newValue;
//               }
//             },
//             selectedItem: defaultValue,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select an option';
//               }
//               return null;
//             },
//           );
//         }
//       },
//     );
//   }
  // Widget dropDownTextEmpty(BuildContext context) {
  //   final noOptionText = '${widget.labelText} not available';
  //   return FutureBuilder<List<String>>(
  //     future: widget.options,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return DropdownButtonFormField<String>(
  //           value: defaultValue,
  //           items: [''].map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //             );
  //           }).toList(),
  //           onChanged: (String? newValue) {
  //             if (newValue != null) {
  //               widget.onChanged(newValue);
  //               defaultValue = newValue;
  //             }
  //           },
  //           decoration: InputDecoration(
  //             labelText: noOptionText,
  //             border: const OutlineInputBorder(),
  //           ),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Text('Error loading options: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return DropdownButtonFormField<String>(
  //           value: defaultValue,
  //           items: [''].map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //             );
  //           }).toList(),
  //           onChanged: (String? newValue) {
  //             if (newValue != null) {
  //               widget.onChanged(newValue);
  //               defaultValue = newValue;
  //             }
  //           },
  //           decoration: InputDecoration(
  //             labelText: noOptionText,
  //             border: const OutlineInputBorder(),
  //           ),
  //         );
  //       } else {
  //         return DropdownButtonFormField<String>(
  //           items: snapshot.data!.map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //             );
  //           }).toList(),
  //           onChanged: (String? newValue) {
  //             if (newValue != null) {
  //               widget.onChanged(newValue);
  //             }
  //           },
  //           decoration: InputDecoration(
  //             labelText: widget.labelText,
  //             border: const OutlineInputBorder(),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
  
  // Widget dropDownTextFilled(BuildContext context) {
  //   final noOptionText = '${widget.labelText} not available';
  //   return FutureBuilder<List<String>>(
  //     future: widget.options,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return DropdownButtonFormField<String>(
  //           value: '',
  //           items: [''].map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //             );
  //           }).toList(),
  //           onChanged: (String? newValue) {
  //             if (newValue != null) {
  //               widget.onChanged(newValue);
  //               defaultValue = newValue;
  //             }
  //           },
  //           decoration: InputDecoration(
  //             labelText: noOptionText,
  //             border: const OutlineInputBorder(),
  //           ),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Text('Error loading options: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return DropdownButtonFormField<String>(
  //           value: defaultValue,
  //           items: [''].map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //             );
  //           }).toList(),
  //           onChanged: (String? newValue) {
  //             if (newValue != null) {
  //               widget.onChanged(newValue);
  //               defaultValue = newValue;
  //             }
  //           },
  //           decoration: InputDecoration(
  //             labelText: noOptionText,
  //             border: const OutlineInputBorder(),
  //           ),
  //         );
  //       } else {
  //         List<String> dropdownItems = snapshot.data!;
  //         if (activated) {
  //           if (widget.data != null) {
  //             int dataIndex = dropdownItems.indexOf(widget.data!);
  //             defaultValue = dataIndex != -1 ? widget.data! : dropdownItems.first;
  //           } else {
  //             defaultValue = dropdownItems.isNotEmpty ? dropdownItems.first : '';
  //           }
  //           activated = false;
  //         }

  //         return DropdownButtonFormField<String>(
  //           value: defaultValue,
  //           items: snapshot.data!.map((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
  //             );
  //           }).toList(),
  //           onChanged: (String? newValue) {
  //             if (newValue != null) {
  //               widget.onChanged(newValue);
  //               defaultValue = newValue;
  //             }
  //           },
  //           decoration: InputDecoration(
  //             fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
  //             labelText: widget.labelText,
  //             border: const OutlineInputBorder(),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
// }
