import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/text_field.dart';

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
      appBar: CommonAppBar(currentTitle: 'Add Customer'),
      body: 
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              BuildTextField(controller: _businessNameController, labelText: 'Business Name'),
              const SizedBox(height: 16.0),
              BuildTextField(controller: _contactPersonController, labelText: 'Contact Person'),
              const SizedBox(height: 16.0),
              BuildTextField(controller: _emailController, labelText: 'Email'),
              const SizedBox(height: 16.0),
              BuildTextField(controller: _phoneNoController, labelText: 'Phone Number'),
              const SizedBox(height: 16.0),
              BuildTextField(controller: _billingAddressController, labelText: 'Billing Address'),
              const SizedBox(height: 16.0),
              BuildTextField(controller: _shippingAddressController, labelText: 'Shipping Address'),
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
                    String? businessName = validateTextField(_businessNameController.text, 'Business name');
                    String? contactPerson = validateTextField(_contactPersonController.text, 'Contact person');
                    String? email = validateTextField(_emailController.text, 'Email');
                    String? phoneNumber = validateTextField(_phoneNoController.text, 'Phone number');
                    String? billingAddress = validateTextField(_billingAddressController.text, 'Billing address');
                    String? shippingAddress = validateTextField(_shippingAddressController.text, 'Shipping address');
                    if (businessName == null ||
                        contactPerson == null ||
                        email == null ||
                        phoneNumber == null ||
                        billingAddress == null ||
                        shippingAddress == null) {
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
            ],
          ),
        ),
      ),
    );
  }
}
