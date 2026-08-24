// lib/app/views/interest/interest_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/interest/interest_controller.dart';
import '../../core/app_fonts.dart';
import '../../core/app_images.dart';

import '../../widgets/interestChip/CoustomInterestChip.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';
import '../../widgets/TextFeiled/CustomText.dart';

class InterestView extends StatelessWidget {
  final InterestController controller = Get.put(InterestController());

  InterestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("ما هي اهتماماتك؟", style: AppFonts.TitleStyle.copyWith(fontSize: 26)),
                  SizedBox(
                    width: 150,
                    height: 170,
                    child: Lottie.asset(AppImages.readingNews, fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: "اختر ما يثير فضولك لتجربة مخصصة لك",
                    color: Colors.grey.shade600,
                    fontFamily: "Cairo",
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // --- الجزء الذي سيعرض البيانات الديناميكية ---
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.categories.isEmpty) {
                      return const Center(child: Text('لا توجد تصنيفات متاحة حالياً.'));
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.8,
                      ),
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];

                        // Obx داخلي لمراقبة حالة الاختيار لكل عنصر
                        return Obx(() {
                          final bool isSelected = controller.isCategorySelected(category.id);
                          return Coustominterestchip(
                            // تأكد من أن Coustominterestchip يقبل String كـ 'name'
                            name: category.name,
                            icon: Icons.check_circle, // يمكنك تغيير الأيقونة لاحقاً
                            isSelected: isSelected,
                            onTap: () => controller.toggleCategorySelection(category.id),
                          );
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 32),

                  // --- زر المتابعة ---
                  Obx(() {
                    return CustomContainerButton(
                      text: "متابعة",
                      onTap: controller.isSaving.value ? null : controller.saveAndContinue,
                      child: controller.isSaving.value
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : null,
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
