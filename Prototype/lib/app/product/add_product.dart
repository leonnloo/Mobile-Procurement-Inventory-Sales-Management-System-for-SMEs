// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prototype/app/product/get_product.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/appbar/common_appbar.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.updateData});
  final Function? updateData;
  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final RequestUtil requestUtil = RequestUtil();

  // late TextEditingController _procurementNameController;
  late TextEditingController _productNameController;
  late TextEditingController _unitPriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _markupController;
  late TextEditingController _marginController;
  late TextEditingController _criticalLevelController;

  @override
  void initState() {
    super.initState();
    // _procurementNameController = TextEditingController();
    _productNameController = TextEditingController();
    _unitPriceController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _markupController = TextEditingController();
    _marginController = TextEditingController();
    _criticalLevelController = TextEditingController();
  }

  @override
  void dispose() {
    // _procurementNameController.dispose();
    _productNameController.dispose();
    _unitPriceController.dispose();
    _sellingPriceController.dispose();
    _markupController.dispose();
    _marginController.dispose();
    _criticalLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(currentTitle: 'Add Product'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildTextField(controller: _productNameController, labelText: 'Product Name'),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _unitPriceController, 
                  labelText: 'Unit Price', 
                  onChanged: (value) {
                    calculateMarkupAndMargin(_unitPriceController, _sellingPriceController, _marginController, _markupController);
                    _marginController.text = '${_marginController.text}%';
                    _markupController.text = '${_markupController.text}%';
                  },
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _sellingPriceController, 
                  labelText: 'Selling Price', 
                  onChanged: (value) {
                    calculateMarkupAndMargin(_unitPriceController, _sellingPriceController, _marginController, _markupController);
                    _marginController.text = '${_marginController.text}%';
                    _markupController.text = '${_markupController.text}%';
                  },
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _markupController, 
                  labelText: 'Markup', 
                  onChanged: (value){
                    calculateSellingPrice(_unitPriceController, _sellingPriceController, _markupController);
                  },
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _marginController, 
                  labelText: 'Margin', 
                  onChanged: (value){
                    calculateSellingPrice(_unitPriceController, _sellingPriceController, _markupController);
                  },
                  floatData: true,
                ),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _criticalLevelController, 
                  labelText: 'Critical Level',  
                  onChanged: (value){},
                  floatData: false,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 15.0)
                    ),
                    onPressed: () async {
                      String? productName = validateTextField(_productNameController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? sellingPrice= validateTextField(_sellingPriceController.text);
                      String? margin = validateTextField(_marginController.text);
                      String? markup = validateTextField(_markupController.text);
                      String? criticalLevel = validateTextField(_criticalLevelController.text);
                      if (productName == null
                        || unitPrice == null
                        || sellingPrice == null
                        || margin == null
                        || markup == null
                        || criticalLevel == null) {
                        // Display validation error messages
                        _formKey.currentState?.validate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the required fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {                
                        final response = await requestUtil.newProduct(
                          productName, unitPrice, sellingPrice, margin, markup, criticalLevel
                        );
                        
                        if (response.statusCode == 200) {
                          if (widget.updateData != null) {
                            widget.updateData!();
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added successfully.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Display an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('DONE')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}