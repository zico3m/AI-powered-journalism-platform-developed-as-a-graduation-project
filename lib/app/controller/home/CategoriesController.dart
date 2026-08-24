// lib/app/controllers/categories/categories_controller.dart

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesController extends GetxController {
  final _client = Supabase.instance.client;

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final response = await _client
          .from('categories')
          .select('id, name')
          .order('name');

      categories.assignAll(
        (response as List).cast<Map<String, dynamic>>(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
