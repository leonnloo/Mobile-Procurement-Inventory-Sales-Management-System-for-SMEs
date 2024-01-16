import 'package:flutter/material.dart';
import 'package:prototype/app/supplier/add_supplier.dart';
import 'package:prototype/models/supplierdata.dart';
import 'package:prototype/app/supplier/supplier_info.dart';


class SupplierManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            rows: suppliers.map((SupplierData supplier) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(supplier.supplierID.toString()),
                    onTap: () {
                      navigateToSupplierDetail(context, supplier);
                    },
                  ),
                  DataCell(
                    Text(supplier.supplierName ?? 'N/A'),
                    onTap: () {
                      navigateToSupplierDetail(context, supplier);
                    },
                  ),
                  DataCell(
                    Text(supplier.contactPerson ?? 'N/A'),
                    onTap: () {
                      navigateToSupplierDetail(context, supplier);
                    },
                  ),
                  DataCell(
                    Text(supplier.email ?? 'N/A'),
                    onTap: () {
                      navigateToSupplierDetail(context, supplier);
                    },
                  ),
                  DataCell(
                    Text(supplier.phoneno),
                    onTap: () {
                      navigateToSupplierDetail(context, supplier);
                    },
                  ),
                  DataCell(
                    Text(supplier.address),
                    onTap: () {
                      navigateToSupplierDetail(context, supplier);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen for adding new supplier info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddSupplierScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

