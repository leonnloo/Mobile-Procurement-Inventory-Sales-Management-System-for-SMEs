// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/user_profile/get_user.dart';
import 'package:prototype/models/user_model.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/dropdown_field.dart';
import 'package:prototype/widgets/forms/password_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class EditUser extends StatefulWidget {
  final User user;
  final Function updateData;

  const EditUser({super.key, required this.user, required this.updateData});

  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends State<EditUser> {
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _employeeNameController.text = widget.user.employeeName;
    _emailController.text = widget.user.email;
    _phoneNoController.text = widget.user.phoneNumber;
    _passwordController.text = widget.user.password;
    _roleController.text = widget.user.role;
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.red[400],
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(
              Icons.delete,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.8,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildTextField(controller: _employeeNameController, labelText: 'Business Name', data: widget.user.employeeName),
                  const SizedBox(height: 16.0),
                  BuildTextField(controller: _emailController, labelText: 'Email', data: widget.user.email),
                  const SizedBox(height: 16.0),
                  BuildTextField(controller: _phoneNoController, labelText: 'Phone Number', data: widget.user.phoneNumber),
                  const SizedBox(height: 16.0),
                  PasswordTextField(controller: _passwordController, labelText: 'Password'),
                  const SizedBox(height: 16.0),
                  DropdownTextField(
                    labelText: 'Role', 
                    options: getRoles(), 
                    onChanged: (value){
                      _roleController.text = value!;
                    },
                    defaultSelected: true,
                    data: _roleController.text,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: const RoundedRectangleBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 15.0)
                        ),
                        onPressed: () async {
                          String? employeeName = validateTextField(_employeeNameController.text);
                          String? email = validateTextField(_emailController.text);
                          String? phoneNumber = validateTextField(_phoneNoController.text);
                          String? password = validateTextField(_passwordController.text);
                          String? role = validateTextField(_roleController.text);
                          if (employeeName == null ||
                              role == null ||
                              email == null ||
                              phoneNumber == null ||
                              password == null) {
                            _formKey.currentState?.validate();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all the required fields.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {                
                            final response = await requestUtil.updateUser(
                              widget.user.employeeID, employeeName, email, password, phoneNumber, role
                            );
                            
                            if (response.statusCode == 200) {
                              widget.updateData();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Customer added successfully.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              // Display an error message to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(jsonDecode(response.body)['detail']),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('DONE')
                      ),
                    ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Account Deletion"),
          content: const Text("Are you sure you want to delete account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Handle the deletion logic here
                // You can call a function to perform the deletion or any other action
                // For now, just close the dialog
                final response = await requestUtil.deleteUser(widget.user.employeeID);
                
                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Supplier deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Display an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Supplier delete failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}