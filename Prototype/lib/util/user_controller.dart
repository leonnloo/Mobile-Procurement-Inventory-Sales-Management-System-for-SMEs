import 'package:get/get.dart';

class UserLoggedInController extends GetxController {
  static UserLoggedInController get find => Get.find();
  
  RxString currentUser = ''.obs;
  RxString currentUserID = ''.obs;
  void updateUser(String username) async {
    currentUser.value = username;
  }

  void updateUserID(String userID) async {
    currentUserID.value = userID;
  }
}