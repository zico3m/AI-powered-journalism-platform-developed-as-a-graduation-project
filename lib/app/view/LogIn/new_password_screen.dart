import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/login_controller.dart';
import '../../core/app_colors.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});

  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.08;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "تعيين كلمة مرور جديدة",
                    style: TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  Obx(() => CustomTextFieldForm(
                    maxLines: 1,
                    errorText: controller.newPassError,
                    onChanged: (val) =>
                    controller.newPassword.value = val,
                    obscured: controller.isPasswordHidden.value,
                    hintText: "كلمة المرور الجديدة",
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed:
                      controller.togglePasswordVisibility,
                    ),
                  )),

                  const SizedBox(height: 20),

                  Obx(() => CustomContainerButton(
                    text: controller.isLoading.value
                        ? "جارٍ الحفظ..."
                        : "تحديث كلمة المرور",
                    onTap: controller.isLoading.value
                        ? null
                        : controller.updatePassword,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
