// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/models/supplier_model.dart';
import 'package:prototype/util/get_controllers/supplier_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class EditSupplier extends StatefulWidget {
  final SupplierData supplierData;
  const EditSupplier({super.key, required this.supplierData});

  @override
  EditSupplierState createState() => EditSupplierState();
}

class EditSupplierState extends State<EditSupplier> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final SupplierController controller = Get.put(SupplierController());
  Function? update;
  @override
  void initState() {
    super.initState();
    update = controller.updateData.value;
    _businessNameController.text = widget.supplierData.businessName;
    _contactPersonController.text = widget.supplierData.contactPerson;
    _emailController.text = widget.supplierData.email;
    _phoneNoController.text = widget.supplierData.phoneNo;
    _addressController.text = widget.supplierData.address;
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Edit Supplier', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
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
                BuildTextField(controller: _businessNameController, labelText: 'Business Name', data: widget.supplierData.businessName),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _contactPersonController, labelText: 'Contact Person', data: widget.supplierData.contactPerson),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _emailController, labelText: 'Email', data: widget.supplierData.email),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _phoneNoController, labelText: 'Phone Number', data: widget.supplierData.phoneNo),
                const SizedBox(height: 16.0),
                BuildTextField(controller: _addressController, labelText: 'Address', data: widget.supplierData.address),
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
                          final response = await requestUtil.updateSupplier(
                            widget.supplierData.supplierID, businessName, contactPerson, email, phoneNumber, address
                          );
                          
                          if (response.statusCode == 200) {
                            controller.updateSupplierInfo(SupplierData(supplierID: widget.supplierData.supplierID, businessName: businessName, contactPerson: contactPerson, email: email, phoneNo: phoneNumber, address: address, notes: widget.supplierData.notes));
                            controller.clearSuppliers();
                            Function? updateEdit = controller.updateEditData.value;
                            updateEdit!();
                            update!();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Supplier edited successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Display an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Supplier edit failed: ${jsonDecode(response.body)['detail']}'),
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
                final response = await requestUtil.deleteSupplier(widget.supplierData.supplierID);
                
                if (response.statusCode == 200) {
                  controller.clearSuppliers();
                  update!();
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
                    SnackBar(
                      content: Text('Supplier deletion failed: ${jsonDecode(response.body)['detail']}'),
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