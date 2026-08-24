import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/problems/complaint_controller.dart';
import '../../core/app_colors.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class ComplaintView extends StatelessWidget {
  ComplaintView({super.key});

  final ComplaintController controller =
  Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? AppColor.darkBackground : AppColor.background;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("تقديم شكوى",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// الاسم
            CustomTextFieldForm(
              controller: controller.nameController,
              labelText: "الاسم",
              hintText: "ادخل اسمك",
              onChanged: (_) {},
            ),

            /// البريد
            CustomTextFieldForm(
              controller: controller.emailController,
              labelText: "البريد الإلكتروني",
              hintText: "example@email.com",
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {},
            ),

            /// عنوان المشكلة
            CustomTextFieldForm(
              controller: controller.subjectController,
              labelText: "عنوان المشكلة",
              hintText: "مثال: خطأ في عرض الأخبار",
              onChanged: (_) {},
            ),

            /// سبب المشكلة
            CustomTextFieldForm(
              controller: controller.reasonController,
              labelText: "تفاصيل الشكوى",
              hintText: "اكتب تفاصيل المشكلة هنا...",
              maxLines: 4,
              onChanged: (_) {},
            ),

            const SizedBox(height: 30),

            /// زر الإرسال مع Loading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return CustomContainerButton(
                  onTap: controller.isLoading.value
                      ? null
                      : controller.submitComplaint,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "إرسال الشكوى",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
