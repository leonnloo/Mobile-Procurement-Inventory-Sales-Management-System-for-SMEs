import 'package:flutter/material.dart';
import 'package:prototype/models/supplierdata.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  AddSupplierScreenState createState() => AddSupplierScreenState();
}

class AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _supplierNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _supplierNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _supplierNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      SupplierData newSupplier = SupplierData(
        supplierID: 0, // Assign a unique ID (can generate or get from a database)
        supplierName: _supplierNameController.text,
        contactPerson: _contactPersonController.text,
        email: _emailController.text,
        phoneno: _phoneNoController.text,
        address: _addressController.text,
      );


      print(newSupplier);

      // Close the screen
      Navigator.of(context).pop();
    }
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
                controller: _supplierNameController,
                decoration: const InputDecoration(labelText: 'Supplier Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter supplier name';
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
                decoration: const InputDecoration(labelText: 'Shipping Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shipping address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
