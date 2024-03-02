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

  Future<http.Response> login(String username, String password) async {
    return http.post(
      Uri.parse("${endpoint}token"),
      body: {
        'username': username,
        'password': password,
      },
    );
  }

  Future<http.Response> register(String username, String email, String phoneNumber, String password, String role) async {
    return http.post(
      Uri.parse("${endpoint}register"),
      body: {
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'role': role,
      },
    );
  }

  Future<http.Response> getUsers() async {
    return http.get(
      Uri.parse("${endpoint}get_users"),
    );
  }

  Future<http.Response> getUser(String id) async {
    return http.get(
      Uri.parse("${endpoint}get_user/$id"),
    );
  }

  Future<http.Response> deleteUser(String id) async {
    return http.delete(
      Uri.parse("${endpoint}delete_user/$id"),
    );
  }

  Future<http.Response> updateUser(String id, String username, String email, String password, String phoneNumber, String role) async {
    return http.put(
      Uri.parse("${endpoint}update_user/$id"),
      body: {
        'username': username,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'role': role,
      },
    );
  }

  Future<http.Response> createUser(String username, String email, String password, String phoneNumber) async {
    return http.post(
      Uri.parse("${endpoint}create_user"),
      body: {
        'username': username,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      },
    );
  }
}
