import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:prototype/widgets/fade_in_animation/fade_in_controller.dart';

class FadeInAnimation extends StatelessWidget {
  FadeInAnimation({
    Key? key,
    required this.durantionInMs,
    required this.child,
    this.animate,
  }) : super(key: key);

  final controller = Get.put(FadeInController());
  final int durantionInMs;
  final AnimatePosition? animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: durantionInMs),
        top: controller.animate.value ? animate!.topAfter : animate!.topBefore,
        bottom: controller.animate.value ? animate!.bottomAfter : animate!.bottomBefore,
        left: controller.animate.value ? animate!.leftAfter : animate!.leftBefore,
        right: controller.animate.value ? animate!.rightAfter : animate!.rightBefore,
        child: AnimatedOpacity(
          opacity: controller.animate.value ? 1 : 0,
          duration: Duration(milliseconds: durantionInMs),
          child: child,
        )
      )
    );
  }
}
