import 'package:get/get.dart';


class FadeInController extends GetxController {
  static FadeInController get find => Get.find();
  
  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
  }

  void resetAnimation(){
    animate.value = false;
  }
}