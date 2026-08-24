// lib/app/bindings/initial_binding.dart

import 'package:get/get.dart';

import '../controller/TTS/TtsController.dart';
import '../controller/TTS/WeatherController.dart';
import '../controller/auth/login_controller.dart';
import '../controller/favorites/SavedNewsController.dart';
import '../controller/home/CategoriesController.dart';
import '../controller/home/HomeController.dart';
import '../controller/notifications/NotificationsController.dart';
import '../controller/profile/ProfileController.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(HomeController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    // Get.put(ProfileController(), permanent: true);
    Get.put(WeatherController(), permanent: true);
    Get.put(LoginController(), permanent: true);
    Get.put(CategoriesController(), permanent: true);
    Get.put(SavedNewsController(), permanent: true);
    Get.put(NewsTtsController(), permanent: true);

  }
}
