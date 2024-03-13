import 'package:flutter/material.dart';
import 'package:prototype/models/supplierdata.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void _importSupplierFromContacts() async {
    // 请求访问设备联系人权限
    var permissionStatus = await Permission.contacts.request();

    // 检查权限状态
    if (permissionStatus.isGranted) {
      // 获取联系人列表
      Iterable<Contact> contacts = await ContactsService.getContacts();

      // 显示联系人选择器
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

      // 将选择的联系人信息填充到文本框中
      if (selectedContact != null) {
        setState(() {
          _supplierNameController.text = selectedContact.displayName ?? '';
          _contactPersonController.text = selectedContact.givenName ?? '';
          _emailController.text = selectedContact.emails?.isNotEmpty ?? false ? selectedContact.emails!.first.value ?? '' : '';
          _phoneNoController.text = (selectedContact.phones?.isNotEmpty ?? false ? selectedContact.phones!.first.value : '')!;
          _addressController.text = (selectedContact.postalAddresses?.isNotEmpty ?? false ? selectedContact.postalAddresses!.first.street : '')!;
        });
      }
    } else {
      // 如果用户未授予联系人访问权限，则提示用户
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Required'),
            content: const Text('Please grant permission to access contacts in order to import supplier information.'),
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
      body: SingleChildScrollView(
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
                onPressed: _importSupplierFromContacts,
                child: const Text('Import Supplier from Contacts'),
              ),
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

