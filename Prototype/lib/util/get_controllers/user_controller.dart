import 'package:get/get.dart';
import 'package:prototype/models/user_model.dart';

class UserLoggedInController extends GetxController {
  static UserLoggedInController get find => Get.find();
  
  RxString currentUser = ''.obs;
  RxString currentUserID = ''.obs;
  Rx<User?> currentUserInfo = Rx<User?>(null);
  Rx<Function?> updateDrawer = Rx<Function?>(null);
  void updateUser(String username) async {
    currentUser.value = username;
  }

  void updateUserID(String userID) async {
    currentUserID.value = userID;
  }

  void updateUserInfo(User user) {
    currentUserInfo.value = user;
  }
  
  void updateDrawerFunction(Function func) {
    updateDrawer.value = func;
  }

  // Optional: if you need to clear userInfo (set it to null)
  void clearUserInfo() {
    currentUserInfo.value = null;
  }
  
  // Optional: if you need to clear updateDrawer (set it to null)
  void clearUpdateDrawer() {
    updateDrawer.value = null;
  }
}