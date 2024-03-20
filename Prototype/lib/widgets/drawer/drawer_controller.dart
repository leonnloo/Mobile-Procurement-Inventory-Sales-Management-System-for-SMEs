import 'package:get/get.dart';
import 'package:prototype/models/drawer_sections.dart';

class CustomDrawerController extends GetxController {
  static CustomDrawerController get find => Get.find();
  
  Rx currentPage = DrawerSections.dashboard.obs;

  void changePage(DrawerSections section) async {
    currentPage.value = section;
  }
}