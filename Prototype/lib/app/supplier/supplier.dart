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
  String? _selectedFilter = 'ID';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SupplierController controller = Get.put(SupplierController());
    controller.updateData.value = updateData;
    controller.updateFilter.value = updateFilter;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: GestureDetector(
                  onTap: () {
                    showSearch(context: context, delegate: SupplierSearch(controller.currentSupplierList.value!));
                  },
                  child: const TextField(
                    decoration: InputDecoration(
                      enabled: false,
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder(
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
                  supplierData = _fetchAndFilterSuppliers(supplierData);
                  Function update = controller.updateFilter.value!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 16.0,
                        horizontalMargin: 16.0,
                        columns: [
                          DataColumn(
                            label: Row(
                              children: [
                                Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                Icon(
                                  trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                            onSort: (columnIndex, ascending) {
                              ascending = trackAscending;
                              trackAscending = !ascending;
                              update('ID');
                            },
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text('Business Name', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                Icon(
                                  trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                            onSort: (columnIndex, ascending) {
                              ascending = trackAscending;
                              trackAscending = !ascending;
                              update('Business Name');
                            },
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text('Contact Person', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                Icon(
                                  trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                            onSort: (columnIndex, ascending) {
                              ascending = trackAscending;
                              trackAscending = !ascending;
                              update('Contact Person');
                            },
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text('Email', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                Icon(
                                  trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                            onSort: (columnIndex, ascending) {
                              ascending = trackAscending;
                              trackAscending = !ascending;
                              update('Email');
                            },
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text('Phone Number', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                Icon(
                                  trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                            onSort: (columnIndex, ascending) {
                              ascending = trackAscending;
                              trackAscending = !ascending;
                              update('Phone Number');
                            },
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text('Address', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                Icon(
                                  trackAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                            onSort: (columnIndex, ascending) {
                              ascending = trackAscending;
                              trackAscending = !ascending;
                              update('Address');
                            },
                          ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
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
  bool trackAscending = false;

  List<SupplierData> _fetchAndFilterSuppliers(List<SupplierData> supplier) {
    if (_selectedFilter == null) {
      return [];
    } else {
      switch (_selectedFilter) {
        case 'ID':
          return supplier
            ..sort((a, b) {
              int idA = int.parse(a.supplierID.substring(2)); // Extract numeric part from supplierID
              int idB = int.parse(b.supplierID.substring(2));
              return trackAscending ? idA.compareTo(idB) : idB.compareTo(idA);
            });
        case 'Business Name':
          return supplier..sort((a, b) => trackAscending ? a.businessName.toLowerCase().compareTo(b.businessName.toLowerCase()) : b.businessName.toLowerCase().compareTo(a.businessName.toLowerCase()));        
        case 'Contact Person':
          return supplier..sort((a, b) => trackAscending ? a.contactPerson.toLowerCase().compareTo(b.contactPerson.toLowerCase()) : b.contactPerson.toLowerCase().compareTo(a.contactPerson.toLowerCase()));        
        case 'Address':
          return supplier..sort((a, b) => trackAscending ? a.address.toLowerCase().compareTo(b.address.toLowerCase()) : b.address.toLowerCase().compareTo(a.address.toLowerCase()));
        case 'Email':
          return supplier..sort((a, b) => trackAscending ? a.email.toLowerCase().compareTo(b.email.toLowerCase()) : b.email.toLowerCase().compareTo(a.email.toLowerCase()));
        case 'Phone Number':
          return supplier..sort((a, b) => trackAscending ? a.phoneNo.toLowerCase().compareTo(b.phoneNo.toLowerCase()) : b.phoneNo.toLowerCase().compareTo(a.phoneNo.toLowerCase()));
        default:
          return supplier;
      }
    }
  }
  void updateData() async {
    if (mounted) {
      setState(() {
        futureBuilderKey = UniqueKey();
      });
    }
  }

  void updateFilter(String filter) async {
    if (mounted) {
      setState(() {
        _selectedFilter = filter;
      });
    }
  }
}
class SupplierSearch extends SearchDelegate<String> {
  SupplierSearch(this.supplierList);

  List<SupplierData> supplierList;

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<SupplierData> suggestionList = query.isEmpty
        ? []
        : supplierList.where((item) {
            // Adjusted to match the SupplierData properties
            final searchableString = '${item.supplierID} ${item.businessName} ${item.contactPerson} '
                '${item.email} ${item.phoneNo} ${item.address} ${item.notes ?? ""}'.toLowerCase();

            return searchableString.contains(query.toLowerCase());
        }).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
            final SupplierData item = suggestionList[index];
            // Display information relevant to SupplierData
            return ListTile(
                title: Text(item.businessName), // Using businessName as the main title
                subtitle: Text('Contact: ${item.contactPerson} - Phone: ${item.phoneNo}'),
                onTap: () {
                    navigateToSupplierDetail(context, item);
                },
            );
        },
    );

  }


  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  String get searchFieldLabel => 'Enter Query';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
        color: Theme.of(context).colorScheme.onPrimaryContainer, // Change this to the desired color
        toolbarHeight: 60
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 22),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 22),

      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 22),

      )
    );
  }
}
