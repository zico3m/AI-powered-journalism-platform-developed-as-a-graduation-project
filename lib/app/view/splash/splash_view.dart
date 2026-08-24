import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/splash/Splash_controller.dart';
import '../../core/app_images.dart';

class SplashView extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          AppImages.splashicon,
          fit: BoxFit.cover, // تملأ الشاشة بالكامل
        ),
      ),
    );
  }
}
