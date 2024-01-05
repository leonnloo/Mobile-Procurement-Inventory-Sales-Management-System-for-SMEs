import 'package:flutter/material.dart';
import 'package:prototype/models/procurementdata.dart';

class AddProcurementScreen extends StatefulWidget {
  @override
  _AddProcurementScreenState createState() => _AddProcurementScreenState();
}

class _AddProcurementScreenState extends State<AddProcurementScreen> {
  final _formKey = GlobalKey<FormState>();

  // late TextEditingController _procurementNameController;
  late TextEditingController _productIDController;
  late TextEditingController _supplierIDController;
  late TextEditingController _orderDateController;
  late TextEditingController _deliveryDateController;
  late TextEditingController _totalPriceController;
  late TextEditingController _quantityController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    // _procurementNameController = TextEditingController();
    _productIDController = TextEditingController();
    _supplierIDController = TextEditingController();
    _orderDateController = TextEditingController();
    _deliveryDateController = TextEditingController();
    _totalPriceController = TextEditingController();
    _quantityController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _productIDController.dispose();
    _supplierIDController.dispose();
    _orderDateController.dispose();
    _deliveryDateController.dispose();
    _totalPriceController.dispose();
    _quantityController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      PurchasingOrder newProcurement = PurchasingOrder(
        // orderNumber: 0, // Assign a unique ID (can generate or get from a database)
        productID: int.tryParse(_productIDController.text) ?? 0,
        supplierID: int.tryParse(_supplierIDController.text) ?? 0,
        orderDate: _orderDateController.text,
        deliveryDate: _deliveryDateController.text,
        totalPrice: double.tryParse(_totalPriceController.text) ?? 0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
        status: _statusController.text,
      );


      print(newProcurement);

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
        _orderDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _deliveryDateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Procurement'),
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
                  controller: _productIDController,
                  decoration: InputDecoration(labelText: 'Product ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _supplierIDController,
                  decoration: InputDecoration(labelText: 'Supplier ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter supplier ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _orderDateController,
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
                  controller: _deliveryDateController,
                  decoration: InputDecoration(labelText: 'Delivery date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery date';
                    }
                    return null;
                  },
                  onTap: () async {
                    await _selectDeliveryDate(context);
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