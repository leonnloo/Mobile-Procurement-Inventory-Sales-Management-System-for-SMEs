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
}
