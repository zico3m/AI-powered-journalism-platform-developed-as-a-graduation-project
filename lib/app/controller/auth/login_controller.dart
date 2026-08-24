
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../../core/utils/functions/validatunputs.dart';
import '../../models/data/services/auth_rep/AuthRepository.dart';
import '../../routes/app_routes.dart';
import '../profile/ProfileController.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var email = ''.obs;
  var password = ''.obs;

  var emailError = RxnString();
  var passError = RxnString();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  var resetCode = ''.obs;
  var newPassword = ''.obs;

  var codeError = RxnString();
  var newPassError = RxnString();

  var deletePassword = ''.obs;
  var deletePassError = RxnString();


  Future<void> login() async {
    print("=== ⛔ بدء عملية تسجيل الدخول ===");

    if (!validateInputs()) {
      print("❌ فشل التحقق من المدخلات");
      return;
    }

    isLoading.value = true;

    try {
      await Supabase.instance.client.auth.signOut();
      print("📩 محاولة تسجيل الدخول عبر Supabase...");
      final response = await _authRepository.signIn(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      final user = response.user;

      // ⚠️ أمان إضافي (نادراً تحدث)
      if (user == null) {
        showSnackbar(
          'خطأ',
          'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
          isError: true,
        );
        return;
      }

      // ❌ البريد غير مفعل
      if (user.emailConfirmedAt == null) {
        showSnackbar(
          'تنبيه',
          'يرجى تفعيل بريدك الإلكتروني.',
          isError: true,
        );
        return;
      }

      print("📥 جلب ملف المستخدم...");
      final userProfile = await _authRepository.getUserProfile(user.id);

      if (userProfile == null) {
        showSnackbar(
          'خطأ',
          'لم يتم العثور على ملف المستخدم.',
          isError: true,
        );
        return;
      }

      if (userProfile.accountStatusId == 2) {
        showSnackbar(
          'تنبيه',
          'تم إيقاف حسابك، يرجى مراجعة الإدارة.',
          isError: true,
        );
        return;
      }

      // ➡️ التوجيه
      // if (userProfile.hasSelectedInterests) {
      //   Get.offAllNamed(AppRoutes.HOME);
      // } else {
      //   Get.offAllNamed(AppRoutes.INTEREST);
      // }

      if (userProfile.userTypeId == 3) {
        Get.offAllNamed(AppRoutes.editorHome);
        return;
      }

      if (userProfile.userTypeId == 1 ||
          userProfile.userTypeId == 2) {

        if (userProfile.hasSelectedInterests) {
          Get.offAllNamed(AppRoutes.HOME);
        } else {
          Get.offAllNamed(AppRoutes.INTEREST);
        }

        return;
      }

      Get.offAllNamed(AppRoutes.INTEREST);


    }   on AuthException catch (e) {
      print("🔥 AuthException: ${e.message}");

      if (e.message.toLowerCase().contains('invalid login credentials')) {
        showSnackbar(
          'خطأ',
          'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
          isError: true,
        );
      }
      else if (e.message.toLowerCase().contains('email not confirmed')) {
        showSnackbar(
          'تنبيه',
          'يرجى تفعيل بريدك الإلكتروني.',
          isError: true,
        );
      }
      else {
        showSnackbar(
          'خطأ',
          'حدث خطأ أثناء تسجيل الدخول، حاول لاحقًا.',
          isError: true,
        );
      }
    } catch (e) {
      print("🔥 Exception: $e");
      showSnackbar(
        'خطأ غير متوقع',
        'حدث خطأ ما، يرجى المحاولة لاحقًا.',
        isError: true,
      );
    } finally {
      print("=== 🟦 انتهاء عملية تسجيل الدخول ===");
      isLoading.value = false;
    }
  }




  // ---------------------- التحقق من الحقول ----------------------
  bool validateInputs() {
    emailError.value = ValidInput.validateEmail(email.value);
    passError.value = ValidInput.validatePassword(password.value);
    return emailError.value == null && passError.value == null;
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();

      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar("خطأ", "فشل تسجيل الخروج");
    }
  }





  // ---------------------- رسائل الواجهة ----------------------
  void showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor:
      isError ? Colors.blueAccent.withOpacity(0.8) : Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> sendResetCode() async {
    emailError.value = ValidInput.validateEmail(email.value);
    if (emailError.value != null) return;

    isLoading.value = true;

    try {
      final success =
      await _authRepository.sendResetCode(email.value.trim());

      if (success) {
        showSnackbar("تم الإرسال", "تم إرسال كود التحقق إلى بريدك");
        Get.toNamed(AppRoutes.VERIFY_RESET,);
      } else {
        showSnackbar("خطأ", "فشل في إرسال الكود", isError: true);
      }
    } catch (e) {
      print("🔥 ERROR SEND RESET: $e");
      showSnackbar("خطأ", e.toString(), isError: true);
    }
    finally {
      isLoading.value = false;
    }
  }



  Future<void> verifyResetCode() async {

    print("📧 EMAIL: ${email.value}");
    print("🔐 CODE: ${resetCode.value}");

    isLoading.value = true;

    try {
      final success = await _authRepository.verifyResetCode(
        email: email.value.trim(),
        code: resetCode.value.trim(),
      );

      print("✅ VERIFY RESULT: $success");

      if (success) {
        showSnackbar("تم التحقق", "يمكنك الآن تعيين كلمة سر جديدة");
        Get.toNamed(AppRoutes.NEW_PASSWORD);
      } else {
        showSnackbar("خطأ", "الكود غير صحيح", isError: true);
      }

    } catch (e) {
      print("🔥 VERIFY ERROR: $e");
      showSnackbar("خطأ", "فشل التحقق", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void setResetEmail(String emailValue) {
    email.value = emailValue;
  }





  Future<void> updatePassword() async {
    newPassError.value =
        ValidInput.validatePassword(newPassword.value);

    if (newPassError.value != null) return;

    isLoading.value = true;
    print("EMAIL BEFORE UPDATE: ${email.value}");

    try {
      final success = await _authRepository.updatePassword(
        email: email.value.trim(),
        newPassword: newPassword.value.trim(),
      );

      if (success) {
        showSnackbar("نجاح", "تم تغيير كلمة المرور بنجاح");
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        showSnackbar("خطأ", "فشل تحديث كلمة المرور", isError: true);
      }
    } catch (e) {
      print("🔥 UPDATE ERROR: $e");
      showSnackbar("خطأ", e.toString(), isError: true);
    }
    finally {
      isLoading.value = false;
    }
  }



  Future<void> deleteAccount() async {
    if (deletePassword.value.trim().isEmpty) {
      showSnackbar("خطأ", "يرجى إدخال كلمة المرور", isError: true);
      return;
    }

    try {
      isLoading.value = true;

      await _authRepository.deleteAccount(
        deletePassword.value.trim(),
      );

      showSnackbar("تم", "تم حذف الحساب نهائياً");

      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppRoutes.LOGIN);

    } catch (e) {
      showSnackbar("خطأ", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }



}
