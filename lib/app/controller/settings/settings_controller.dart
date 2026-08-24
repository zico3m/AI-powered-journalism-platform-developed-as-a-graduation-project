import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/services/SupabaseService.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;


  final RxBool loading = false.obs;

  String get email => _client.auth.currentUser?.email ?? '';

  Future<void> logout() async {
    loading.value = true;

    try {
      await _client.auth.signOut();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      loading.value = false;
    }
  }
}
