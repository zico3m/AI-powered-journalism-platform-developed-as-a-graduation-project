import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/interest/edit_interests_controller.dart';
import '../../core/app_fonts.dart';
import '../../core/app_colors.dart';
import '../../widgets/buttmn/CustomContainerButton.dart';

class EditInterestsDialog extends StatelessWidget {
  const EditInterestsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditInterestsController());

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // العنوان
                  Row(
                    children: [
                      Text(
                        "إدارة اهتماماتي",
                        style: AppFonts.titilebody.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // قائمة الاهتمامات داخل قيود ثابتة
                  SizedBox(
                    height: 280,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.categories.map((cat) {
                          final isSelected = controller.selectedCategoryIds.contains(cat.id);

                          return ChoiceChip(
                            label: Text(
                              cat.name,
                              style: const TextStyle(fontFamily: "Cairo", fontSize: 13),
                            ),
                            selected: isSelected,
                            selectedColor: Colors.blue.withOpacity(0.2),
                            onSelected: (_) => controller.toggleCategory(cat.id),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // زر الحفظ
                  Obx(() {
                    return CustomContainerButton(
                      text: controller.isSaving.value ? "جارٍ الحفظ..." : "حفظ الاهتمامات",
                      onTap: controller.isSaving.value ? null : controller.saveInterests,
                    );
                  }),
                ],
              );
            }),
          ),
        ),
      ),
    );

  }
}
