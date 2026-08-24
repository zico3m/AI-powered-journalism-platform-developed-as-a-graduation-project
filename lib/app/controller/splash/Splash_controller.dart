import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // استيراد Supabase

import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  // Future<void> _redirect() async {
  //   await Future.delayed(const Duration(seconds: 3));
  //
  //   // final session = Supabase.instance.client.auth.currentSession;
  //   final user = Supabase.instance.client.auth.currentUser;
  //
  //   final box = GetStorage();
  //   final seenOnboarding = box.read<bool>('seenOnboarding') ?? false;
  //   if (!seenOnboarding) {
  //     Get.offAllNamed(AppRoutes.ONBOARDING);
  //   } else if (user != null) {
  //     Get.offAllNamed(AppRoutes.HOME);
  //   } else {
  //     Get.offAllNamed(AppRoutes.LOGIN);
  //   }
  //
  // }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = Supabase.instance.client.auth.currentUser;
    final box = GetStorage();
    final seenOnboarding = box.read<bool>('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      Get.offAllNamed(AppRoutes.ONBOARDING);
      return;
    }

    if (user == null) {
      Get.offAllNamed(AppRoutes.LOGIN);
      return;
    }

    // ✅ Fetch user profile from Supabase
    final response = await Supabase.instance.client
        .from('users') // <-- your table name
        .select()
        .eq('id', user.id)
        .single();

    final int userTypeId = response['user_type_id'];
    final bool hasSelectedInterests =
        response['has_selected_interests'] ?? false;

    // ✅ SAME logic as LoginController
    if (userTypeId == 3) {
      Get.offAllNamed(AppRoutes.editorHome);
      return;
    }

    if (userTypeId == 1 || userTypeId == 2) {
      if (hasSelectedInterests) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.offAllNamed(AppRoutes.INTEREST);
      }
      return;
    }

    Get.offAllNamed(AppRoutes.INTEREST);
  }



}

