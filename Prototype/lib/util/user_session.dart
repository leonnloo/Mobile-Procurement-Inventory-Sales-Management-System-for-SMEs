import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:prototype/models/user_model.dart';
import 'package:prototype/util/get_controllers/user_controller.dart';
import 'package:prototype/util/request_util.dart';

class UserSession {
  static const _storage = FlutterSecureStorage();
  static final RequestUtil requestUtil = RequestUtil();
  static final userLoggedInController = Get.put(UserLoggedInController());
  static Future<void> saveUserSession(String userId, String token) async {
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'token', value: token);
  }

  static Future<bool> isUserLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final id = await _storage.read(key: 'userId');
    if (token != null && id != null){
      final response = await requestUtil.getUser(id);
      if (response.statusCode == 200) {
        dynamic user = jsonDecode(response.body);
        userLoggedInController.currentUserInfo.value = User.fromJson(user);
        userLoggedInController.currentUser.value = token; 
        userLoggedInController.currentUserID.value = id;
      } else {
        // if user is deleted or internet connection unavailable
        return false;
      }
    }
    return token != null;
  }

  static Future<void> clearUserSession() async {
    await _storage.deleteAll();
  }
}
