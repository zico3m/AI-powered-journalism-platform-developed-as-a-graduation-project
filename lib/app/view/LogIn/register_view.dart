// lib/app/views/signin/register_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// تأكد من أن هذه المسارات صحيحة بناءً على هيكل مشروعك

import '../../controller/auth/register_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_images.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';
import 'Login_View.dart';

class RegisterView extends StatelessWidget {

  final RegisterController controller = Get.put(RegisterController());

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.08;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 170,
                    child: Lottie.asset(AppImages.login, fit: BoxFit.fill),
                  ),


                  CustomTextFieldForm(
                    controller: controller.nameController,
                    errorText: controller.nameError,
                    onChanged: (val) => controller.name.value = val,
                    hintText: "الاسم",
                    prefixIcon: const Icon(Icons.person),
                  ),


                  CustomTextFieldForm(
                    controller: controller.emailController,
                    errorText: controller.emailError,
                    onChanged: (val) => controller.email.value = val,
                    hintText: 'email_hint'.tr,
                    prefixIcon: const Icon(Icons.email),
                  ),


              Obx(() {
                return CustomTextFieldForm(
                  suffixIcon: Icon(Icons.lock),
                  maxLines: 1,
                  controller: controller.passController,
                  errorText: controller.passError,
                  onChanged: (val) => controller.password.value = val,
                  obscured: controller.isPasswordHidden.value,
                  hintText: 'password_hint'.tr,
                  prefixIcon: GestureDetector(
                    onTap: controller.togglePasswordVisibility,
                    child: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                );
              }),


              Obx(() {
                return CustomTextFieldForm(
                  suffixIcon: Icon(Icons.lock),
                  maxLines: 1,
                  controller: controller.confPassController,
                  errorText: controller.confPassError,
                  onChanged: (val) => controller.confirmPassword.value = val,
                  obscured: controller.isPasswordHidden.value,
                  hintText: 'confirm_password_hint'.tr,
                prefixIcon: GestureDetector(
                    onTap: controller.togglePasswordVisibility,
                    child: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                );
              }),


                  Obx(() {
                    return CustomContainerButton(

                      text: 'register'.tr,
                      onTap: controller.isLoading.value
                          ? null // تعطيل الزر أثناء التحميل
                          : controller.register,
                      child: controller.isLoading.value
                          ? const Center(
                          child: CircularProgressIndicator(

                              color: Colors.yellow))
                          : null,
                    );
                  }),


                  TextButton(
                    onPressed: () {
                      // استخدام Get.off() أفضل من Get.to() للانتقال بين صفحات المصادقة
                      // لأنه يزيل الصفحة الحالية من المكدس
                      Get.off(() => LoginView());
                    },
                    child: Text(
                      'have_account_login'.tr,
                      style: TextStyle(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
