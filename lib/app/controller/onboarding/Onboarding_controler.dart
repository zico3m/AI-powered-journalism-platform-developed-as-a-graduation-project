import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class OnboardingControler extends GetxController {
  var currentpage = 0.obs;
  final PageController pageController = PageController();

  void nextPage() {
    if (currentpage.value < 2) {
      currentpage.value++;
      pageController.animateToPage(
        currentpage.value,
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
    } else {
    }
  }

  void onPageChange(int index) {
    currentpage.value = index;
  }

  void finishOnboarding() {
    // _stoargeservices.isFirstOpen=false;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
