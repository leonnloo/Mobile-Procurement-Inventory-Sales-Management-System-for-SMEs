import 'package:flutter/material.dart';

class AddClaimRefundForm extends StatefulWidget {
  const AddClaimRefundForm({Key? key}) : super(key: key);

  @override
  _AddClaimRefundFormState createState() => _AddClaimRefundFormState();
}

class _AddClaimRefundFormState extends State<AddClaimRefundForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _customerNameController;
  late TextEditingController _customerIdController;
  late TextEditingController _dateController;
  late TextEditingController _reasonController;
  late TextEditingController _amountController;
  late TextEditingController _statusController;

  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController();
    _customerIdController = TextEditingController();
    _dateController = TextEditingController();
    _reasonController = TextEditingController();
    _amountController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerIdController.dispose();
    _dateController.dispose();
    _reasonController.dispose();
    _amountController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission here
      /* Connect to backend
        ````````
      */
      // Simulate submission success
      setState(() {
        _isSubmitted = true;
      });
      // After a certain delay, hide the success message
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isSubmitted = false;
        });
      });
      //Navigator.of(context).popUntil((route) => route.settings.name == '/CustomerClaimsRefundsScreen');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Claim or Refund'),
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
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerIdController,
                decoration: InputDecoration(labelText: 'Customer ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date';
                  }
                  return null;
                },
                onTap: () async {
                  await _selectDate(context);
                },
              ),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reason';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              // Conditional rendering of success message
              if (_isSubmitted)
                SizedBox(height: 16.0),
              Visibility(
                visible: _isSubmitted, // 将文本隐藏

                child: Text(
                  'Form submitted successfully!',
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
