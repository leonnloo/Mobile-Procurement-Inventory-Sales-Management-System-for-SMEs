// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/util/get_controllers/customer_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class EditCustomer extends StatefulWidget {
  final CustomerData customerData;
  const EditCustomer({super.key, required this.customerData});

  @override
  EditCustomerState createState() => EditCustomerState();
}

class EditCustomerState extends State<EditCustomer> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _shippingAddressController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final customerController = Get.put(CustomerController());
  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.customerData.businessName;
    _contactPersonController.text = widget.customerData.contactPerson;
    _emailController.text = widget.customerData.email;
    _phoneNoController.text = widget.customerData.phoneNo;
    _billingAddressController.text = widget.customerData.billingAddress;
    _shippingAddressController.text = widget.customerData.shippingAddress;
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Edit Customer', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(
              Icons.delete,
              size: 24.0,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildTextField(controller: _businessNameController, labelText: 'Business Name', data: widget.customerData.businessName),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _contactPersonController, labelText: 'Contact Person', data: widget.customerData.contactPerson),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _emailController, labelText: 'Email', data: widget.customerData.email),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _phoneNoController, labelText: 'Phone Number', data: widget.customerData.phoneNo),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _billingAddressController, labelText: 'Billing Address', data: widget.customerData.billingAddress),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _shippingAddressController, labelText: 'Shipping Address', data: widget.customerData.shippingAddress),
                const SizedBox(height: 16.0),
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
                        String? billingAddress = validateTextField(_billingAddressController.text);
                        String? shippingAddress = validateTextField(_shippingAddressController.text);
                        if (businessName == null ||
                            contactPerson == null ||
                            email == null ||
                            phoneNumber == null ||
                            billingAddress == null ||
                            shippingAddress == null) {
                          // Display validation error messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please fill in all the required fields.'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {                
                          final response = await requestUtil.updateCustomer(
                            widget.customerData.customerID, businessName, contactPerson, email, phoneNumber, billingAddress, shippingAddress
                          );
                          
                          if (response.statusCode == 200) {
                            Function? update = customerController.updateData.value;
                            Function? updateEdit = customerController.updateEditData.value;
                            customerController.updateCustomerInfo(CustomerData(customerID: widget.customerData.customerID, businessName: businessName, contactPerson: contactPerson, email: email, phoneNo: phoneNumber, billingAddress: billingAddress, shippingAddress: shippingAddress, notes: widget.customerData.notes));
                            customerController.clearCustomers();
                            customerController.getCustomers();
                            update!();
                            updateEdit!();
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
                                backgroundColor: Theme.of(context).colorScheme.error,
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
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete?"),
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
                final response = await requestUtil.deleteCustomer(widget.customerData.customerID);
                
                if (response.statusCode == 200) {
                  Function? update = customerController.updateData.value;
                  Function? updateEdit = customerController.updateEditData.value;
                  customerController.clearCustomers();
                  customerController.getCustomers();
                  update!();
                  updateEdit!();
                  Navigator.pop(context);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer deleted successfully.'),
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