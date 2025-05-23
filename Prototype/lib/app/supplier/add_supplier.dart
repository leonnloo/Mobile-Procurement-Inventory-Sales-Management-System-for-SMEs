// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/util/get_controllers/supplier_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});
  @override
  AddSupplierScreenState createState() => AddSupplierScreenState();
}

class AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();
  final SupplierController controller = Get.put(SupplierController());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Add Supplier'),
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
              BuildTextField(controller: _addressController, labelText: 'Address'),
              const SizedBox(height: 40.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    side: const BorderSide(color: Colors.black),
                    shape: const RoundedRectangleBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 15.0)
                  ),
                  onPressed: () async {
                    String? businessName = validateTextField(_businessNameController.text);
                    String? contactPerson = validateTextField(_contactPersonController.text);
                    String? email = validateTextField(_emailController.text);
                    String? phoneNumber = validateTextField(_phoneNoController.text);
                    String? address = validateTextField(_addressController.text);
                    if (businessName == null ||
                        contactPerson == null ||
                        email == null ||
                        phoneNumber == null ||
                        address == null) {
                      // Display validation error messages
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please fill in all the required fields.'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    } else {                
                      final response = await requestUtil.newSupplier(
                        businessName, contactPerson, email, phoneNumber, address
                      );
                      
                      if (response.statusCode == 200) {
                        controller.clearSuppliers();
                        Function? update = controller.updateData.value;
                        if (update != null){
                          update();
                        }
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
                            backgroundColor: Theme.of(context).colorScheme.error,
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
