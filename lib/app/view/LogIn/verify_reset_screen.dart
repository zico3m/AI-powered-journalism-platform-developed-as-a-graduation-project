import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naba_ai/app/routes/app_pages.dart';
import 'package:naba_ai/app/routes/app_routes.dart';
import '../../controller/auth/login_controller.dart';
import '../../core/app_colors.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class VerifyResetScreen extends StatelessWidget {
  VerifyResetScreen({super.key});

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
                  Row(
                    children: [

                      const Text(
                        "أدخل كود التحقق",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),

                      FilledButton(onPressed: (){
                        Get.toNamed(AppRoutes.LOGIN);
                      }, child: Icon(Icons.arrow_back_ios_new_outlined)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  CustomTextFieldForm(
                    errorText: controller.codeError,

                    onChanged: (val) => controller.resetCode.value = val,
                    obscured: false,
                    hintText: "الكود",
                    suffixIcon: const Icon(Icons.lock),
                  ),

                  const SizedBox(height: 20),

                  Obx(() => CustomContainerButton(
                    text: controller.isLoading.value
                        ? "جارٍ التحقق..."
                        : "تحقق",
                    onTap: controller.isLoading.value
                        ? null
                        : controller.verifyResetCode,
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
