import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/datamodles/problems/complaint_model.dart';
import '../../models/data/services/problems/complaint_repository.dart';

class ComplaintController extends GetxController {
  final ComplaintRepository _repository = ComplaintRepository();

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final reasonController = TextEditingController();

  /// Loading State
  var isLoading = false.obs;

  /// إرسال الشكوى
  Future<void> submitComplaint() async {
    if (!_validateFields()) return;

    try {
      isLoading.value = true;

      final user = Supabase.instance.client.auth.currentUser;

      final complaint = ComplaintModel(
        userId: user?.id, // null إذا غير مسجل
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        subject: subjectController.text.trim(),
        reason: reasonController.text.trim(),
      );

      await _repository.submitComplaint(complaint);

      Get.snackbar(
        "تم الإرسال",
        "تم إرسال شكواك بنجاح",
        snackPosition: SnackPosition.BOTTOM,
      );

      _clearFields();
      Get.back(); // يغلق الديالوج

    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الإرسال",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// التحقق من الحقول
  bool _validateFields() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        subjectController.text.isEmpty ||
        reasonController.text.isEmpty) {
      Get.snackbar(
        "تنبيه",
        "يرجى ملء جميع الحقول",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  /// تفريغ الحقول
  void _clearFields() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    reasonController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}
