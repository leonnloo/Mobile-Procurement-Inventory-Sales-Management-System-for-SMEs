import 'package:get/get.dart';

class UserLoggedInController extends GetxController {
  static UserLoggedInController get find => Get.find();
  
  RxString currentUser = ''.obs;

  void updateUser(String username) async {
    currentUser.value = username;
  }
}