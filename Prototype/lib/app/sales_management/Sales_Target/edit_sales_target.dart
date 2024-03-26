// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/models/monthly_sales_model.dart';
import 'package:prototype/util/management_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/number_field.dart';

class EditSalesTarget extends StatefulWidget {
  final MonthlySales targetMonth;
  final Function updateData;

  const EditSalesTarget({super.key, required this.targetMonth, required this.updateData});

  @override
  EditSalesTargetState createState() => EditSalesTargetState();
}

class EditSalesTargetState extends State<EditSalesTarget> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _actualSalesController = TextEditingController();
  final TextEditingController _targetSalesController = TextEditingController();
  final ManagementUtil managementUtil = ManagementUtil();

  @override
  void initState() {
    super.initState();
    _yearController.text = widget.targetMonth.year.toString();
    _monthController.text = widget.targetMonth.month.toString();
    _actualSalesController.text = widget.targetMonth.actualSales.toStringAsFixed(2);
    _targetSalesController.text = widget.targetMonth.targetSales.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _actualSalesController.dispose();
    _targetSalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Edit Sales Target'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _targetSalesController, 
                  labelText: 'Set New Target', 
                  onChanged: ((value) {
                    _targetSalesController.text = value;
                  }), 
                  floatData: true,
                ),
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
                        String? year = validateTextField(_yearController.text);
                        String? month = validateTextField(_monthController.text);
                        String? actualSales = validateTextField(_actualSalesController.text);
                        String? targetSales = validateTextField(_targetSalesController.text);
                        if (year == null
                          || month == null
                          || actualSales == null
                          || targetSales == null) {
                          // Display validation error messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter new target.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {                
                          final response = await managementUtil.updateMonthlyTargetSales(
                            year, month, actualSales, targetSales
                          );
                          
                          if (response.statusCode == 200) {
                            widget.updateData();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Target updated successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Display an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Target failed: ${jsonDecode(response.body)['detail']}'),
                                backgroundColor: Colors.red,
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
}