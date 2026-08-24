import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/auth/login_controller.dart';
import '../../core/app_colors.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});
  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.08;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 18),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
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
                  // Name

                  // Email
                  CustomTextFieldForm(
                    errorText: controller.emailError,
                    onChanged: (val) => controller.email.value = val,
                    obscured: false,
                    hintText: "البريد الإلكتروني",
                    suffixIcon: Icon(Icons.email),
                  ),

                  // Password

                  // Register Button
                  Obx(() => CustomContainerButton(

                    text: controller.isLoading.value
                        ? "جارٍ الإرسال..."
                        : "إرسال كود التحقق",
                    onTap: controller.isLoading.value
                        ? null
                        : controller.sendResetCode,
                  )),

                  // Login Redirect
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
