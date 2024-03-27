import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/supplier/add_supplier.dart';
import 'package:prototype/models/supplier_model.dart';
import 'package:prototype/app/supplier/supplier_info.dart';
import 'package:prototype/util/get_controllers/supplier_controller.dart';
import 'package:prototype/util/request_util.dart';


class SupplierManagementScreen extends StatefulWidget {
  const SupplierManagementScreen({super.key});

  @override
  State<SupplierManagementScreen> createState() => _SupplierManagementScreenState();
}

class _SupplierManagementScreenState extends State<SupplierManagementScreen> {
  final RequestUtil requestUtil = RequestUtil();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SupplierController controller = Get.put(SupplierController());
    controller.updateData.value = updateData;
    return Scaffold(
      body: FutureBuilder(
        key: futureBuilderKey,
        future: controller.getSuppliers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: size.height * 0.8,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: double.infinity,
              height: size.height * 0.9,
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load supplier data",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // Assuming snapshot.data is a List<SupplierData>
            List<SupplierData> supplierData = snapshot.data as List<SupplierData>;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 16.0,
                  horizontalMargin: 16.0,
                  columns: [
                    DataColumn(label: Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Name', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Contact Person', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Email', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Phone No', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DataColumn(label: Text('Address', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                  ],
                  rows: supplierData.map((SupplierData supplier) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(supplier.supplierID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier);
                          },
                        ),
                        DataCell(
                          Text(supplier.businessName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier);
                          },
                        ),
                        DataCell(
                          Text(supplier.contactPerson, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier);
                          },
                        ),
                        DataCell(
                          Text(supplier.email, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier);
                          },
                        ),
                        DataCell(
                          Text(supplier.phoneNo, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier);
                          },
                        ),
                        DataCell(
                          Text(supplier.address, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
          else {
            return Container(); // Return an empty container if none of the conditions match
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        onPressed: () {
          // Navigate to a screen for adding new supplier info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddSupplierScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}

