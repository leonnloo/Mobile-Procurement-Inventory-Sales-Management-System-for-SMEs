import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prototype/util/get_controllers/user_controller.dart';

class ChatbotUtil {
  late final String ipAddress;
  final int port = 8000;
  late final String endpoint;
  var token = '';
  var currentUser = '';
  var currentUserID = '';
  final userLoggedInController = Get.put(UserLoggedInController());
  ChatbotUtil() {
    // ipAddress = InternetAddress.loopbackIPv4.address;
    // ipAddress = "10.0.2.2";
    ipAddress = "20.2.87.52";
    endpoint = "http://$ipAddress:$port/";
    token = userLoggedInController.currentUser.value;
    currentUser = userLoggedInController.currentUser.value;
    currentUserID = userLoggedInController.currentUserID.value;
  }

  Future<http.Response> sendMessage(String message) async {
    final response = await http.post(
    Uri.parse("${endpoint}chat"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sentence': message
      }),
    );

    return response;
  }

}