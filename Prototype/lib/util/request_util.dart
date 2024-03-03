import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';

class RequestUtil {
  late final String ipAddress;
  final int port = 8000;
  late final String endpoint;

  RequestUtil() {
    // ipAddress = InternetAddress.loopbackIPv4.address;
    ipAddress = "10.0.2.2";
    endpoint = "http://$ipAddress:$port/";
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
    return http.get(
      Uri.parse("${endpoint}get_user/$id"),
    );
  }

  Future<http.Response> getUsers() async {
    return http.get(
      Uri.parse("${endpoint}get_users"),
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
      body: {
        'employee_name': username,
        'password': password,
        'email': email,
        'phone_number': phoneNumber,
        'role': role,
      },
    );
  }

  Future<http.Response> deleteUser(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_user/$id"),
    );
  }


  // ----------------------------------------- CUSTOMER ----------------------------------------------
  Future<http.Response> newCustomer(String businessName, String contactPerson, String email, String phoneNumber, String billingAddress, String shippingAddress) async {
    return http.post(
      Uri.parse("${endpoint}customer_form"),
      body: {
        'customer_id': null,
        'business_name': businessName,
        'contact_person': contactPerson,
        'email': email,
        'phone_number': phoneNumber,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        
      }
    );
  }




}
