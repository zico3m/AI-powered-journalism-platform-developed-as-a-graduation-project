// lib/app/bindings/splash_binding.dart
import 'package:get/get.dart';

import '../controller/auth/login_controller.dart';
import '../controller/splash/Splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

