import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/models/customerdata.dart';
import 'package:prototype/util/request_util.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  AddCustomerScreenState createState() => AddCustomerScreenState();
}

class AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();

  late TextEditingController _businessNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _billingAddressController;
  late TextEditingController _shippingAddressController;
  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _billingAddressController = TextEditingController();
    _shippingAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _billingAddressController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
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
                decoration: const InputDecoration(labelText: 'Customer Name'),
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
                controller: _billingAddressController,
                decoration: const InputDecoration(labelText: 'Billing Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter billing address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _shippingAddressController,
                decoration: const InputDecoration(labelText: 'Shipping Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shipping address';
                  }
                  return null;
                },
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
                    // Add your authentication logic here
                    String? businessName = _businessNameController.text;
                    String? contactPerson = _contactPersonController.text;
                    String? email = _emailController.text;
                    String? phoneNumber = _phoneNoController.text;
                    String? billingAddress = _billingAddressController.text;
                    String? shippingAddress = _shippingAddressController.text;
                    if (businessName != null ||
                        contactPerson != null ||
                        email != null ||
                        phoneNumber != null ||
                        billingAddress != null ||
                        shippingAddress != null) {
                      // Display validation error messages
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all the required fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {                
                      final response = await requestUtil.newCustomer(
                        businessName, contactPerson, email, phoneNumber, billingAddress, shippingAddress
                      );
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                      } else {
                        // Failed login
                        // print("Register failed");
                        // print("Error: ${response.body}");
                        
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
                  child: const Text('SIGN UP')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
