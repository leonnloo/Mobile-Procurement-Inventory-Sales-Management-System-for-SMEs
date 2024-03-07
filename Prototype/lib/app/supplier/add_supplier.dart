import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype/util/request_util.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  AddSupplierScreenState createState() => AddSupplierScreenState();
}

class AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();

  late TextEditingController _businessNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _validateTextField(String value, String fieldName) {
    if (value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Supplier'),
      ),
      body: 
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _businessNameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(labelText: 'Contact Person'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact person';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNoController,
                decoration: const InputDecoration(labelText: 'Phone No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40.0),
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
                    String? businessName = _validateTextField(_businessNameController.text, 'Business name');
                    String? contactPerson = _validateTextField(_contactPersonController.text, 'Contact person');
                    String? email = _validateTextField(_emailController.text, 'Email');
                    String? phoneNumber = _validateTextField(_phoneNoController.text, 'Phone number');
                    String? address = _validateTextField(_addressController.text, 'Address');
                    if (businessName == null ||
                        contactPerson == null ||
                        email == null ||
                        phoneNumber == null ||
                        address == null) {
                      // Display validation error messages
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all the required fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {                
                      final response = await requestUtil.newSupplier(
                        businessName, contactPerson, email, phoneNumber, address
                      );
                      
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Supplier added successfully.'),
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
            ],
          ),
        ),
      ),
    );
  }
}
