import 'package:flutter/material.dart';
import 'package:prototype/app/sales/salesorders/orderdata.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // late TextEditingController _procurementNameController;
  late TextEditingController _orderNoController;
  late TextEditingController _dateController;
  late TextEditingController _customerIDController;
  late TextEditingController _productID;
  late TextEditingController _quantityController;
  late TextEditingController _totalPriceController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    // _procurementNameController = TextEditingController();
    _orderNoController = TextEditingController();
    _dateController = TextEditingController();
    _customerIDController = TextEditingController();
    _productID = TextEditingController();
    _quantityController = TextEditingController();
    _totalPriceController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _orderNoController.dispose();
    _dateController.dispose();
    _customerIDController.dispose();
    _productID.dispose();
    _quantityController.dispose();
    _totalPriceController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      SalesOrder newOrder = SalesOrder(
        orderNo: int.tryParse(_orderNoController.text) ?? 0,
        date: _customerIDController.text,
        customerID: int.tryParse(_customerIDController.text) ?? 0,
        productID: int.tryParse(_productID.text) ?? 0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        totalPrice: double.tryParse(_totalPriceController.text) ?? 0,
        status: _statusController.text,
      );


      print(newOrder);

      // Close the screen
      Navigator.of(context).pop();
    }
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
        _customerIDController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
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
                  // controller: _orderNoController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _customerIDController,
                  decoration: InputDecoration(labelText: 'Customer ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter supplier ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Order date'),
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
                  controller: _productID,
                  decoration: InputDecoration(labelText: 'Product'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: InputDecoration(labelText: 'Total Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total price';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter status';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}