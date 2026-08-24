
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';

class CustomContainerButton extends StatelessWidget {
  // --- التعديلات ---
  final String? text;      // 1. جعل النص اختيارياً
  final Widget? child;     // 2. إضافة Widget ابن اختياري
  // -----------------

  final Color? color;
  final void Function()? onTap;

  const CustomContainerButton({
    super.key,
    this.text,
    this.child,
    this.color,
    this.onTap,
  }) : assert(text != null || child != null, 'Either text or child must be provided.');
  // assert: للتأكد من أن المبرمج يوفر إما نصاً أو ابناً، وليس كليهما فارغاً.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55, // يمكنك تعديل الارتفاع حسب تصميمك
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey : (color ?? AppColor.primary), // إذا كان onTap فارغاً، اجعل الزر رمادياً
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (onTap != null) // لا تضف ظلاً إذا كان الزر معطلاً
              BoxShadow(
                color: (color ?? AppColor.primary).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        // --- منطق العرض ---
        // 3. التحقق مما يجب عرضه: الابن (child) له الأولوية
        child: Center(
          child: child ?? Text(
            text!, // علامة التعجب هنا آمنة بسبب الـ assert في الأعلى
            style: AppFonts.titlefortext.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // -------------------
      ),
    );
  }
}
