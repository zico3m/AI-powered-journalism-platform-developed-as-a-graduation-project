import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/functions/validatunputs.dart';
import '../../models/data/services/auth_rep/AuthRepository.dart';
import '../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  // --- Controllers ---
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();

  // لا تغيير هنا، كل شيء ممتاز
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;

  var nameError = RxnString();
  var emailError = RxnString();
  var passError = RxnString();
  var confPassError = RxnString();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;


  Future<void> register() async {
    print("Register button clicked!");
    // <-- أضف هذا السطر
    if (!validateInputs()) return;
    print("Validation failed.");

    isLoading.value = true;
    print("Setting isLoading to true.");
    try {

      final bool emailExists =
          await _authRepository.isEmailAlreadyRegistered(email.value.trim());

      if (emailExists) {
        showSnackbar('خطأ', 'هذا البريد الإلكتروني مسجل بالفعل.',
            isError: true);
        isLoading.value = false;
        return;
      }
      // --------------------------


      await _performSignUp();
    } on AuthException catch (e) {
      showSnackbar('خطأ في التسجيل', e.message, isError: true);
    } catch (e) {
      print("Caught generic exception: $e");
      showSnackbar('خطأ غير متوقع', 'حدث خطأ ما، يرجى المحاولة مرة أخرى.',
          isError: true);
    } finally {
      if (isLoading.value) {
        isLoading.value = false;
      }
    }
  }

  Future<void> _performSignUp() async {
    final response = await _authRepository.signUp(
      email: email.value.trim(),
      password: password.value.trim(),
      name: name.value.trim(),
    );

    if (response.user != null || response.session == null) {
      showSnackbar(
          'نجاح', 'تم إنشاء حسابك. يرجى التحقق من بريدك الإلكتروني للتفعيل.');
      await Future.delayed(const Duration(seconds: 3));
      Get.offNamed(AppRoutes.LOGIN);
    }
  }

  // --- دوال مساعدة (لا تغيير هنا) ---
  bool validateInputs() {
    nameError.value = ValidInput.validateName(name.value);
    emailError.value = ValidInput.validateEmail(email.value);
    passError.value = ValidInput.validatePassword(password.value);
    confPassError.value = ValidInput.validateConfirmPassword(
        password.value, confirmPassword.value);

    return nameError.value == null &&
        emailError.value == null &&
        passError.value == null &&
        confPassError.value == null;
  }

  void showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          isError ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    passController.dispose();
    confPassController.dispose();
    super.onClose();
  }
}
