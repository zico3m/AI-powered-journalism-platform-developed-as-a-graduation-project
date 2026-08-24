import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/auth/login_controller.dart';
import '../../core/app_colors.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class DeletAccount extends StatelessWidget {
  DeletAccount({super.key});

  final LoginController controller = Get.find();
  final agree = false.obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.08;

    return Scaffold(
      appBar: AppBar(
        title: const Text("حذف الحساب",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
          child: Column(
            children: [

              /// 🔴 أيقونة تحذير كبيرة
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 60,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "هل أنت متأكد من حذف حسابك؟",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                  color: isDark
                      ? AppColor.darkTextPrimary
                      : AppColor.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              /// ⚠️ رسالة تنبيه
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  "⚠ عند حذف حسابك:\n\n"
                      "• سيتم حذف جميع بياناتك نهائياً.\n"
                      "• لن تتمكن من استعادة الحساب.\n"
                      "• سيتم حذف مقالاتك وتفاعلاتك.\n\n"
                      "هذا الإجراء غير قابل للتراجع.",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 🔐 إدخال كلمة المرور
              CustomTextFieldForm(
                maxLines: 1,
                onChanged: (val) =>
                controller.deletePassword.value = val,
                obscured: true,
                hintText: "أدخل كلمة المرور للتأكيد",
                suffixIcon: const Icon(Icons.lock_outline),
              ),

              const SizedBox(height: 16),

              /// ☑️ موافقة المستخدم
              Obx(() => CheckboxListTile(
                value: agree.value,
                activeColor: Colors.red,
                onChanged: (val) => agree.value = val ?? false,
                title: const Text(
                  "أوافق على حذف حسابي نهائياً",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              )),

              const SizedBox(height: 25),

              /// 🗑 زر الحذف
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: controller.isLoading.value ||
                      !agree.value
                      ? null
                      : () => _confirmDelete(context),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "حذف الحساب نهائياً",
                    style: TextStyle(
                      fontFamily: "Cairo",
                      fontSize: 15,
                      color: Colors.white
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Dialog تأكيد أخير
  void _confirmDelete(BuildContext context) {
    Get.defaultDialog(
      title: "تأكيد أخير",
      middleText:
      "هل أنت متأكد 100٪ أنك تريد حذف حسابك؟\nلن تتمكن من التراجع.",
      textConfirm: "نعم، احذف",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteAccount();
      },
    );
  }
}
