import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/add_customer.dart';
import 'package:prototype/models/customer_model.dart';
import 'package:prototype/app/customer/customer_info.dart';
import 'package:prototype/util/get_controllers/customer_controller.dart';
import 'package:prototype/util/request_util.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final RequestUtil requestUtil = RequestUtil();
  final customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    customerController.updateData.value = updateData;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: GestureDetector(
                  onTap: () {
                    showSearch(context: context, delegate: CustomerSearch(customerController.currentCustomerList.value!));
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
              future: customerController.getCustomers(),
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
                          color: Theme.of(context).colorScheme.error,
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
                    height: size.height * 0.8,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Unable to load customer data",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  // Assuming snapshot.data is a List<CustomerData>
                  List<CustomerData> customerData = snapshot.data as List<CustomerData>;
            
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 16.0,
                        horizontalMargin: 16.0,
                        columns: [
                          DataColumn(label: Text('ID', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Business Name', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Contact Person', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Email', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Phone No', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Billing Address', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                          DataColumn(label: Text('Shipping Address', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                        ],
                        rows: customerData.map((CustomerData customer) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(customer.customerID, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                              DataCell(
                                Text(customer.businessName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                              DataCell(
                                Text(customer.contactPerson, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                              DataCell(
                                Text(customer.email, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                              DataCell(
                                Text(customer.phoneNo, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                              DataCell(
                                Text(customer.billingAddress, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                              DataCell(
                                Text(customer.shippingAddress, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                onTap: () {
                                  navigateToCustomerDetail(context, customer);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if none of the conditions match
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        onPressed: () {
          // Navigate to a screen for adding new customer info
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddCustomerScreen(),
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

class CustomerSearch extends SearchDelegate<String> {
  CustomerSearch(this.customerList);

  List<CustomerData> customerList;

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<CustomerData> suggestionList = query.isEmpty
        ? []
        : customerList.where((item) {
            // Adjusted to match the CustomerData properties
            final searchableString = '${item.customerID} ${item.businessName} ${item.contactPerson} '
                '${item.email} ${item.phoneNo} ${item.billingAddress} ${item.shippingAddress} ${item.notes ?? ""}'.toLowerCase();

            return searchableString.contains(query.toLowerCase());
        }).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
            final CustomerData item = suggestionList[index];
            // Display information relevant to CustomerData
            return ListTile(
                title: Text(item.businessName), // Using businessName as the main title
                subtitle: Text('Contact: ${item.contactPerson} - Phone: ${item.phoneNo}'),
                onTap: () {
                    navigateToCustomerDetail(context, item);
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
        toolbarHeight: 80
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),

      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 23),

      )
    );
  }
}