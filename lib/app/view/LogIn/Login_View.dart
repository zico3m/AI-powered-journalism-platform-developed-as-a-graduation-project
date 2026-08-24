import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/auth/login_controller.dart';
import '../../core/localization/LanguageController.dart';
import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../../core/app_images.dart';
import '../../routes/app_routes.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';
import '../../widgets/TextFeiled/CustomText.dart';
import '../RootViews/RootView.dart';
import '../problems/complaint_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.find<LoginController>();
  final LanguageController langController =
  Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.08;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.darkBackground : AppColor.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: _LoginCard(
              controller: controller,
              isDark: isDark,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.controller,
    required this.size,
    required this.isDark,
  });

  final LoginController controller;
  final Size size;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                TextButton(onPressed: (){

                  Get.to(ComplaintView());


                }, child: Text(
                  'تقديم شكوى',
                  style: TextStyle(
                    color: isDark ? AppColor.background : AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),),
              ],
            ),
          ),

          /// ───── Animation ─────
          SizedBox(
            width: 150,
            height: 170,
            child: Lottie.asset(
              AppImages.login,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 10),

          /// ───── Email ─────
          CustomTextFieldForm(
            style: AppFonts.titlefortext.copyWith(fontSize: 16),
            errorText: controller.emailError,
            onChanged: (val) => controller.email.value = val,
            obscured: false,
            hintText: 'email_hint'.tr,
            prefixIcon: Icon(
              Icons.email_rounded,
              color: isDark ? AppColor.background : AppColor.primary,
            ),
          ),

          const SizedBox(height: 14),

          /// ───── Password ─────
          Obx(() {
            return CustomTextFieldForm(
              maxLines: 1,
              style: AppFonts.titlefortext.copyWith(fontSize: 16),
              errorText: controller.passError,
              onChanged: (val) => controller.password.value = val,
              obscured: controller.isPasswordHidden.value,
              hintText: 'password_hint'.tr,
              prefixIcon: Icon(
                Icons.lock_rounded,
                color: isDark ? AppColor.background : AppColor.primary,
              ),
              suffixIcon: GestureDetector(
                onTap: controller.togglePasswordVisibility,
                child: Icon(
                  controller.isPasswordHidden.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: isDark ? AppColor.background : AppColor.primary,
                ),
              ),
            );
          }),

          /// ───── Forgot Password ─────
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.offAllNamed(AppRoutes.FORGETPASSWORD);
              },
              child: Text(
                'forgot_password'.tr,
                style: TextStyle(
                  fontFamily: "Cairo",
                  color: isDark ? AppColor.background : AppColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          /// ───── Login Button ─────
          Obx(() {
            return CustomContainerButton(
              text: 'login_in'.tr,
              onTap: controller.isLoading.value ? null : controller.login,
              child: controller.isLoading.value
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : null,
            );
          }),

          SizedBox(height: size.height * 0.02),

          /// ───── Register ─────
          TextButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.REGISTER);
            },
            child: CustomText(
              text: 'no_account_register'.tr,
              color: isDark ? AppColor.background : AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// ───── Guest Login ─────
          TextButton(
            onPressed: () {
              Get.to(RootView());
            },
            child: const CustomText(
              text: "دخول كــ ضيف",
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
