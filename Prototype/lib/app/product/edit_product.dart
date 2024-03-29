// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/product/get_product.dart';
import 'package:prototype/models/product_model.dart';
import 'package:prototype/util/get_controllers/product_controller.dart';
import 'package:prototype/util/request_util.dart';
import 'package:prototype/util/validate_text.dart';
import 'package:prototype/widgets/forms/number_field.dart';
import 'package:prototype/widgets/forms/text_field.dart';

class EditProduct extends StatefulWidget {
  final ProductItem productData;
  const EditProduct({super.key, required this.productData});

  @override
  EditProductState createState() => EditProductState();
}

class EditProductState extends State<EditProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _marginController = TextEditingController();
  final TextEditingController _markupController = TextEditingController();
  final TextEditingController _criticalLevelController= TextEditingController();
  final RequestUtil requestUtil = RequestUtil();
  final productController = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.productData.productName;
    _quantityController.text = widget.productData.quantity.toString();
    _unitPriceController.text = widget.productData.unitPrice.toStringAsFixed(2);
    _sellingPriceController.text = widget.productData.sellingPrice.toStringAsFixed(2);
    _markupController.text = widget.productData.markup;
    _marginController.text = widget.productData.margin;
    _criticalLevelController.text = widget.productData.criticalLvl.toString();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _sellingPriceController.dispose();
    _marginController.dispose();
    _markupController.dispose();
    _criticalLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Edit Purchase', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context),
            icon: const Icon(
              Icons.delete,
              size: 30.0,
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildTextField(controller: _productNameController, labelText: 'Product Name'),
                const SizedBox(height: 16.0),
                IntegerTextField(
                  controller: _quantityController, 
                  labelText: 'Quantity', 
                  onChanged: (value) {},
                  floatData: false,
                ),
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
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        side: const BorderSide(color: Colors.black),
                        shape: const RoundedRectangleBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 15.0)
                      ),
                      onPressed: () async {
                      String? productName = validateTextField(_productNameController.text);
                      String? quantity = validateTextField(_quantityController.text);
                      String? unitPrice = validateTextField(_unitPriceController.text);
                      String? sellingPrice= validateTextField(_sellingPriceController.text);
                      String? margin = validateTextField(_marginController.text);
                      String? markup = validateTextField(_markupController.text);
                      String? criticalLevel = validateTextField(_criticalLevelController.text);
                      if (productName == null
                        || quantity == null 
                        || unitPrice == null
                        || sellingPrice == null
                        || margin == null
                        || markup == null
                        || criticalLevel == null) {
                          // Display validation error messages
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please fill in all the required fields.'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {                
                          final response = await requestUtil.updateProduct(
                            widget.productData.productID ,productName, quantity, unitPrice, sellingPrice, margin, markup, criticalLevel
                          );
                          
                          if (response.statusCode == 200) {
                            Function? update = productController.updateData.value;
                            Function? updateEdit = productController.updateEditData.value;
                            productController.updateProductInfo(ProductItem(productID: widget.productData.productID, productName: productName, unitPrice: double.parse(unitPrice), sellingPrice: double.parse(sellingPrice), quantity: int.parse(quantity), markup: markup, margin: margin, criticalLvl: int.parse(criticalLevel), status: widget.productData.status, monthlySales: widget.productData.monthlySales));
                            productController.clearProducts();
                            productController.getProducts();
                            update!();
                            updateEdit!();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product edited successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            // Display an error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Product edit failed: ${jsonDecode(response.body)['detail']}'),
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
                final response = await requestUtil.deleteProduct(widget.productData.productID);
                
                if (response.statusCode == 200) {
                  Function? update = productController.updateData.value;
                  productController.clearProducts();
                  productController.getProducts();
                  update!();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product item deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Display an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Delete product item failed'),
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