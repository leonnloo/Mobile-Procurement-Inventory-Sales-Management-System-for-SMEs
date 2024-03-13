import 'package:flutter/material.dart';
import 'package:prototype/models/customerdata.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _customerNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _billingAddressController;
  late TextEditingController _shippingAddressController;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _billingAddressController = TextEditingController();
    _shippingAddressController = TextEditingController();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _billingAddressController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      CustomerData newCustomer = CustomerData(
        customerID: 0, // Assign a unique ID (can generate or get from a database)
        customerName: _customerNameController.text,
        contactPerson: _contactPersonController.text,
        email: _emailController.text,
        phoneno: _phoneNoController.text,
        billingAddress: _billingAddressController.text,
        shippingAddress: _shippingAddressController.text,
      );

      print(newCustomer);

      // Close the screen
      Navigator.of(context).pop();
    }
  }

  void _importCustomerFromContacts() async {
    var permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();

      Contact? selectedContact = await showModalBottomSheet<Contact>(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: contacts.map((contact) {
              return ListTile(
                title: Text(contact.displayName ?? ''),
                onTap: () {
                  Navigator.of(context).pop(contact);
                },
              );
            }).toList(),
          );
        },
      );

      if (selectedContact != null) {
        setState(() {
          _customerNameController.text = selectedContact.displayName ?? '';
          _contactPersonController.text = selectedContact.givenName ?? '';
          _emailController.text =
              selectedContact.emails?.isNotEmpty ?? false ? selectedContact.emails!.first.value ?? '' : '';
          _phoneNoController.text =
              (selectedContact.phones?.isNotEmpty ?? false ? selectedContact.phones!.first.value : '')!;
          _billingAddressController.text =
              (selectedContact.postalAddresses?.isNotEmpty ?? false ? selectedContact.postalAddresses!.first.street : '')!;
          _shippingAddressController.text =
              (selectedContact.postalAddresses?.isNotEmpty ?? false ? selectedContact.postalAddresses!.first.street : '')!;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
                'Please grant permission to access contacts in order to import customer information.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _customerNameController,
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
              ElevatedButton(
                onPressed: _importCustomerFromContacts,
                child: const Text('Import Customer from Contacts'),
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
