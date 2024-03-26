import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/app/supplier/add_supplier.dart';
import 'package:prototype/models/supplier_model.dart';
import 'package:prototype/app/supplier/supplier_info.dart';
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
    return Scaffold(
      body: FutureBuilder(
        key: futureBuilderKey,
        future: _fetchSupplierData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 26.0),
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.red[400],
              width: double.infinity,
              height: size.height * 0.9,
              padding: const EdgeInsets.only(top: 20.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unable to load supplier data",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Contact Person')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone No')),
                    DataColumn(label: Text('Address')),
                  ],
                  rows: supplierData.map((SupplierData supplier) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(supplier.supplierID),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier, updateData);
                          },
                        ),
                        DataCell(
                          Text(supplier.businessName),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier, updateData);
                          },
                        ),
                        DataCell(
                          Text(supplier.contactPerson),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier, updateData);
                          },
                        ),
                        DataCell(
                          Text(supplier.email),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier, updateData);
                          },
                        ),
                        DataCell(
                          Text(supplier.phoneNo),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier, updateData);
                          },
                        ),
                        DataCell(
                          Text(supplier.address),
                          onTap: () {
                            navigateToSupplierDetail(context, supplier, updateData);
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
        onPressed: () {
          // Navigate to a screen for adding new supplier info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSupplierScreen(updateData: updateData,),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<SupplierData>> _fetchSupplierData() async {
    try {
      final customer = await requestUtil.getSuppliers();
      if (customer.statusCode == 200) {
        // Assuming the JSON response is a list of objects
        List<dynamic> jsonData = jsonDecode(customer.body);
        
        // Map each dynamic object to SupplierData
        List<SupplierData> supplierData = jsonData.map((data) => SupplierData.fromJson(data)).toList();
        return supplierData;
      } else {
        throw Exception('Unable to fetch supplier data.');
      }
    } catch (error) {
      // print('Error in _fetchSupplierData: $error');
      rethrow; // Rethrow the error to be caught by FutureBuilder
    }
  }

  Key futureBuilderKey = UniqueKey();

  void updateData() async {
    setState(() {
      futureBuilderKey = UniqueKey();
    });
  }
}

