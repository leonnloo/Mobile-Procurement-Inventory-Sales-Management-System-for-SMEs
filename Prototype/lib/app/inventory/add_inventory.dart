import 'package:flutter/material.dart';

class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key});

  @override
  AddInventoryScreenState createState() => AddInventoryScreenState();
}

class AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // late TextEditingController _procurementNameController;
  late TextEditingController _itemIDController;
  late TextEditingController _itemNameController;
  late TextEditingController _categoryController;
  late TextEditingController _quantityController;
  late TextEditingController _unitPriceController;
  late TextEditingController _totalPriceController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _itemIDController = TextEditingController();
    _itemNameController = TextEditingController();
    _categoryController = TextEditingController();
    _quantityController = TextEditingController();
    _unitPriceController = TextEditingController();
    _totalPriceController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _itemIDController.dispose();
    _itemNameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     SalesOrder newOrder = SalesOrder(
  //       orderNo: int.tryParse(_itemIDController.text) ?? 0,
  //       date: _categoryController.text,
  //       customerID: int.tryParse(_categoryController.text) ?? 0,
  //       productID: int.tryParse(_unitPriceController.text) ?? 0,
  //       quantity: int.tryParse(_quantityController.text) ?? 0,
  //       totalPrice: double.tryParse(_totalPriceController.text) ?? 0,
  //       status: _statusController.text,
  //     );


  //     print(newOrder);

  //     // Close the screen
      Navigator.of(context).pop();
  //   }
  }

  Future<void> _selectOrderDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _categoryController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  // controller: _itemIDController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter supplier ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter order date';
                    }
                    return null;
                  },
                  onTap: () async {
                    await _selectOrderDate(context);
                  },
                ),
                TextFormField(
                  controller: _unitPriceController,
                  decoration: const InputDecoration(labelText: 'Unit Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: const InputDecoration(labelText: 'Total Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Low Stock Reminder'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                // TextFormField(
                //   controller: _quantityController,
                //   decoration: InputDecoration(labelText: 'Status'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter status';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}