import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prototype/util/user_controller.dart';

class RequestUtil {
  late final String ipAddress;
  final int port = 8000;
  late final String endpoint;
  var token = '';
  var currentUser = '';
  var currentUserID = '';
  final userLoggedInController = Get.put(UserLoggedInController());
  RequestUtil() {
    // ipAddress = InternetAddress.loopbackIPv4.address;
    ipAddress = "10.0.2.2";
    endpoint = "http://$ipAddress:$port/";
    token = userLoggedInController.currentUser.value;
    currentUser = userLoggedInController.currentUser.value;
    currentUserID = userLoggedInController.currentUserID.value;
  }


  // ----------------------------------------- LOGIN ----------------------------------------------
  Future<http.Response> login(String username, String password) async {
    return http.post(
      Uri.parse("${endpoint}token"),
      body: {
        'username': username,
        'password': password,
      },
    );
  }

  Future<http.Response> getToken(String username) async {
    return http.get(Uri.parse("${endpoint}token/$username"));
  }

  // ----------------------------------------- USER (Employee's info, Registering) ----------------------------------------------
  Future<http.Response> getUser(String id) async {
    // await Future.delayed(const Duration(seconds: 50));
    return http.get(
      Uri.parse("${endpoint}get_user/$id"),
    );
  }

  Future<http.Response> getUsers() async {
    return http.get(
      Uri.parse("${endpoint}get_users"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  
  Future<http.Response> getUsersName() async {
    return http.get(
      Uri.parse("${endpoint}get_users_name"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getUserID(String userName) async {
    return http.get(
      Uri.parse("${endpoint}get_user_id/$userName"),
    );
  }

  Future<http.Response> createUser(String username, String email, String phoneNumber, String password) async {
    final response = await http.post(
    Uri.parse("${endpoint}create_user"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employee_name': username,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      }),
    );

    return response;
  }

  Future<http.Response> updateUser(String id, String username, String email, String password, String phoneNumber, String role) async {
    return http.put(
      Uri.parse("${endpoint}update_user/$id"),
      headers: {'Content-Type': 'application/json', "Authorization": "Bearer $token"},
      body: jsonEncode({
        'employee_name': username,
        'password': password,
        'email': email,
        'phone_number': phoneNumber,
        'role': role,
      }),
    );
  }

  Future<http.Response> updateUserPassword(String email, String newPassword) async {
    return http.put(
      Uri.parse("${endpoint}update_user_password/$email/$newPassword"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> deleteUser(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_user/$id"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  // ----------------------------------------- FORGET PASSWORD ----------------------------------------------
  Future<http.Response> sendVerificationEmail(String email) async {
    return http.get(
      Uri.parse("${endpoint}send_verification_email/$email"),
    );
  }
  Future<http.Response> verifyUser(String email, String code) async {
    return http.post(
      Uri.parse("${endpoint}verify_user/$email/$code"),
    );
  }

  Future<http.Response> verifyEmail(String email) async {
    return http.get(
      Uri.parse("${endpoint}verify_email/$email"),
    );
  }

  // ----------------------------------------- CUSTOMER ----------------------------------------------
  Future<http.Response> getCustomers() async {
    return http.get(
      Uri.parse("${endpoint}get_customers"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  Future<http.Response> getCustomer(String id) async {
    return http.get(
      Uri.parse("${endpoint}get_customer/$id"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  
  Future<http.Response> getCustomersName() async {
    return http.get(
      Uri.parse("${endpoint}get_customers_name"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  
  Future<http.Response> getCustomerID(String customerName) async {
    return http.get(
      Uri.parse("${endpoint}get_customer_id/$customerName"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> newCustomer(String businessName, String contactPerson, String email, String phoneNumber, String billingAddress, String shippingAddress) async {
    return http.post(
      Uri.parse("${endpoint}customer_form"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'business_name': businessName,
        'contact_person': contactPerson,
        'email': email,
        'phone_number': phoneNumber,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      })
    );
  }

  Future<http.Response> updateCustomer(String customerID, String businessName, String contactPerson, String email, String phoneNumber, String billingAddress, String shippingAddress) async {
    return http.put(
      Uri.parse("${endpoint}update_customer/$customerID"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'business_name': businessName,
        'contact_person': contactPerson,
        'email': email,
        'phone_number': phoneNumber,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
      }) 
    );
  }

  Future<http.Response> deleteCustomer(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_customer/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }
  // ----------------------------------------- SUPPLIER ----------------------------------------------

  Future<http.Response> getSupplier(String id) async {
    return http.get(
      Uri.parse("${endpoint}get_supplier/$id"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getSuppliersName() async {
    return http.get(
      Uri.parse("${endpoint}get_suppliers_name"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getSuppliers() async {
    return http.get(
      Uri.parse("${endpoint}get_suppliers"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  
  Future<http.Response> newSupplier(String businessName, String contactPerson, String email, String phoneNumber, String address) async {
    return http.post(
      Uri.parse("${endpoint}supplier_form"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'business_name': businessName,
        'contact_person': contactPerson,
        'email': email,
        'phone_number': phoneNumber,
        'address': address,
      })
    );
  }

  Future<http.Response> updateSupplier(String id, String businessName, String contactPerson, String email, String phoneNumber, String address) async {
    return http.put(
      Uri.parse("${endpoint}update_supplier/$id"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'business_name': businessName,
        'contact_person': contactPerson,
        'email': email,
        'phone_number': phoneNumber,
        'address': address,
      })
    );
  }

  Future<http.Response> deleteSupplier(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_supplier/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // ----------------------------------------- NOTE ----------------------------------------------
  Future<http.Response> getSupplierNote(String id) async {
    return http.get(
      Uri.parse("${endpoint}get_supplier_note/$id"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  Future<http.Response> getCustomerNote(String id) async {
    return http.get(
      Uri.parse("${endpoint}get_customer_note/$id"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  // ! passing in "/" within note will disrupt the url
  Future<http.Response> updateNote(String id, String note) async {
    return http.put(
      Uri.parse("${endpoint}update_note/$note/$id"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    );
  }

  // ----------------------------------------- PROCUREMENT ----------------------------------------------
  Future<http.Response> newProcurement(dynamic itemName, dynamic itemType, dynamic itemID, dynamic supplierName, dynamic orderDate, dynamic deliveryDate, dynamic unitPrice, dynamic totalPrice, dynamic quantity, dynamic status) async { return
  http.post(
    Uri.parse("${endpoint}procurement_form"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'item_name': itemName,
        'item_type': itemType,
        'item_id': itemID,
        'supplier_name': supplierName,
        'order_date': orderDate,
        'delivery_date': deliveryDate,
        'unit_price': unitPrice,
        'total_price':  totalPrice,
        'quantity': quantity,
        'status': status
      })
  ); }

  Future<http.Response> updateProcurement(String id, dynamic itemName, dynamic itemType, dynamic itemID, dynamic supplierName, dynamic orderDate, dynamic deliveryDate, dynamic unitPrice, dynamic totalPrice, dynamic quantity, dynamic status) async {
    return http.put(
      Uri.parse("${endpoint}update_procurement/$id"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'item_name': itemName,
        'item_type': itemType,
        'item_id': itemID,
        'supplier_name': supplierName,
        'order_date': orderDate,
        'delivery_date': deliveryDate,
        'unit_price': unitPrice,
        'total_price':  totalPrice,
        'quantity': quantity,
        'status': status
      })
    );
  }

  Future<http.Response> getProcurement(String category){
    return http.get(
      Uri.parse("${endpoint}get_procurement/$category"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  Future<http.Response> getProcurementCategory(String category){
    return http.get(
      Uri.parse("${endpoint}get_procurement_category/$category"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> deleteProcurement(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_procurement/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // ----------------------------------------- PRODUCT ----------------------------------------------

  Future<http.Response> getProducts(){
    return http.get(
      Uri.parse("${endpoint}get_products"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getProductsName() async {
    return http.get(
      Uri.parse("${endpoint}get_products_name"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  Future<http.Response> getProductID(String productName) async {
    return http.get(
      Uri.parse("${endpoint}get_product_id/$productName"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getProductUnitPrice(String item) async {
    return http.get(
      Uri.parse("${endpoint}get_product_unit_price/$item"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  Future<http.Response> getProductSellingPrice(String itemName) async {
    return http.get(
      Uri.parse("${endpoint}get_product_selling_price/$itemName"),
      headers: {"Authorization": "Bearer $token"}
    );
  }
  Future<http.Response> newProduct(dynamic productName, dynamic unitPrice, dynamic sellingPrice, dynamic margin, dynamic markup, dynamic criticalLevel) async { return
  http.post(
    Uri.parse("${endpoint}product_form"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'product_name': productName,
        'unit_price': unitPrice,
        'selling_price':  sellingPrice,
        'markup': markup,
        'margin': margin,
        'critical_level': criticalLevel
      })
  ); }
  
  Future<http.Response> updateProduct(String productID, dynamic productName, dynamic quantity, dynamic unitPrice, dynamic sellingPrice, dynamic margin, dynamic markup, dynamic criticalLevel) async { return
  http.put(
    Uri.parse("${endpoint}update_product/$productID"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'product_name': productName,
        'quantity': quantity,
        'unit_price': unitPrice,
        'selling_price':  sellingPrice,
        'markup': markup,
        'margin': margin,
        'critical_level': criticalLevel,
      })
  ); }

  Future<http.Response> deleteProduct(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_product/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<http.Response> stockInProduct(String itemName, dynamic quantity) async {
    return http.put(
      Uri.parse("${endpoint}stock_in_product"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'product_name': itemName,
        'quantity': quantity,
      })
    );
  }
  
  Future<http.Response> stockOutProduct(String itemName, dynamic quantity) async {
    return http.put(
      Uri.parse("${endpoint}stock_out_product"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'product_name': itemName,
        'quantity': quantity,
      })
    );
  }

  // ----------------------------------------- INVENTORY ----------------------------------------------
  Future<http.Response> getInventoryType(String category) async {
    return http.get(
      Uri.parse("${endpoint}get_inventory_category/$category"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getInventoryID(String itemName) async {
    return http.get(
      Uri.parse("${endpoint}get_inventory_item_id/$itemName"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getInventoryName() async {
    return http.get(
      Uri.parse("${endpoint}get_inventory_name"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> getInventoryUnitPrice(String itemName) async {
    return http.get(
      Uri.parse("${endpoint}get_inventory_unit_price/$itemName"),
      headers: {"Authorization": "Bearer $token"}
    );
  }

  Future<http.Response> newInventory(dynamic itemName, dynamic category, dynamic unitPrice, dynamic criticalLevel) async { return
  http.post(
    Uri.parse("${endpoint}inventory_form"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'item_name': itemName,
        'category': category,
        'unit_price': unitPrice,
        'critical_level': criticalLevel
      })
  ); }
  Future<http.Response> updateInventory(String itemID, dynamic itemName, dynamic category, dynamic unitPrice, dynamic quantity, dynamic criticalLevel) async { return
  http.put(
    Uri.parse("${endpoint}update_inventory/$itemID"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'item_name': itemName,
        'category': category,
        'unit_price': unitPrice,
        'quantity': quantity,
        'critical_level': criticalLevel
      })
  ); }

  Future<http.Response> deleteInventory(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_inventory/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<http.Response> stockInInventory(String itemName, dynamic quantity) async {
    return http.put(
      Uri.parse("${endpoint}stock_in_inventory"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'item_name': itemName,
        'quantity': quantity,
      })
    );
  }
  
  Future<http.Response> stockOutInventory(String itemName, dynamic quantity) async {
    return http.put(
      Uri.parse("${endpoint}stock_out_inventory"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'item_name': itemName,
        'quantity': quantity,
      })
    );
  }
  
  // ----------------------------------------- SALES ORDER ----------------------------------------------
  Future<http.Response> getSaleOrders() async {
    return http.get(
      Uri.parse("${endpoint}get_sale_orders"),
      headers: {"Authorization": "Bearer $token"}
    );
  }


  Future<http.Response> newOrder(dynamic customerName, dynamic customerID, dynamic productName, dynamic productID, dynamic orderDate, dynamic unitPrice, dynamic totalPrice, dynamic quantity, dynamic status) async { return
  http.post(
    Uri.parse("${endpoint}sales_order_form"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'customer_name': customerName,
        'customer_id': customerID,
        'product_name': productName,
        'product_id': productID,
        'order_date': orderDate,
        'unit_price': unitPrice,
        'total_price':  totalPrice,
        'quantity': quantity,
        'status': status,
        'employee': currentUser,
        'employee_id': currentUserID,
      })
  ); }
  Future<http.Response> updateSaleOrder(String orderID, dynamic customerName, dynamic customerID, dynamic productName, dynamic productID, dynamic orderDate, dynamic unitPrice, dynamic totalPrice, dynamic quantity, dynamic status, dynamic employee, dynamic employeeID) async { return
  http.put(
    Uri.parse("${endpoint}update_sale_order/$orderID"),
    headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
    body: jsonEncode({
        'customer_name': customerName,
        'customer_id': customerID,
        'product_name': productName,
        'product_id': productID,
        'order_date': orderDate,
        'unit_price': unitPrice,
        'total_price':  totalPrice,
        'quantity': quantity,
        'status': status,
        'employee': employee,
        'employee_id': employeeID,
      })
  ); }

  Future<http.Response> deleteOrder(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_sale_order/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<http.Response> setMonthlyTarget(int selectedYear, int selectedMonth, double monthlyTarget) {
    return http.post(
      Uri.parse("${endpoint}sales-management/new_monthly_sales_target"),
      headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'},
      body: jsonEncode({
        'year': selectedYear,
        'month': selectedMonth,
        'actual_sales': 0,
        'target_sales': monthlyTarget,
      })
    );
  }
}


