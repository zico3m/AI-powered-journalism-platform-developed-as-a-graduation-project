import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/ArticleController/CreateArticleController..dart';
import '../../core/app_colors.dart';
import '../../widgets/TextFeiled/CoustomTextFiledForm.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class CreateArticleView extends StatelessWidget {
  CreateArticleView({super.key});

  final controller = Get.put(CreateArticleController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        isDark ? AppColor.darkBackground : AppColor.background,
        appBar: AppBar(
          title: const Text(
            "إنشاء مقال",
            style: TextStyle(
              fontFamily: "Cairo",
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
          isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
          foregroundColor:
          isDark ? AppColor.darkTextPrimary : AppColor.primary,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              /// صورة الغلاف
              Obx(() {
                return GestureDetector(
                  onTap: () => _showImageSheet(isDark),
                  child: Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.darkCardBackground
                          : AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      image: controller.imagePath.value != null
                          ? DecorationImage(
                        image: FileImage(
                          File(controller.imagePath.value!),
                        ),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: controller.imagePath.value == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                            AppColor.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 32,
                            color: AppColor.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "إضافة صورة الغلاف",
                          style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColor.darkTextSecondary
                                : AppColor.textSecondary,
                          ),
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              }),

              const SizedBox(height: 24),

              /// العنوان
              CustomTextFieldForm(
                controller: controller.titleController,
                hintText: "عنوان المقال",
                prefixIcon: Icon(
                  Icons.title_rounded,
                  color: AppColor.primary,
                ),
                obscured: false,
                onChanged: (_) {},
              ),

              const SizedBox(height: 16),

              /// المحتوى
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkCardBackground
                      : AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.contentController,
                  maxLines: 10,
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 15,
                    height: 1.6,
                    color: isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: "محتوى المقال...",
                    hintStyle: TextStyle(
                      fontFamily: "Cairo",
                      fontSize: 14,
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// زر النشر
              Obx(() {
                return CustomContainerButton(
                  text: controller.isLoading.value
                      ? "جارٍ النشر..."
                      : "نشر المقال",
                  onTap: controller.isLoading.value
                      ? null
                      : controller.publishArticle,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= Bottom Sheet =================
  void _showImageSheet(bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
          isDark ? AppColor.darkCardBackground : AppColor.cardBackground,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: (isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.textSecondary)
                    .withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            _imageOption(
              icon: Icons.camera_alt_rounded,
              title: "التقاط صورة",
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
            _imageOption(
              icon: Icons.photo_library_rounded,
              title: "اختيار من المعرض",
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primary),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "Cairo",
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
