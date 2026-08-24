
import 'package:flutter/material.dart';

class Coustominterestchip extends StatelessWidget {
  // --- التعديل 1: تغيير نوع البيانات ---
  final String name;      // أصبحنا نستقبل الاسم مباشرة
  final IconData icon;    // نستقبل الأيقونة مباشرة
  final bool isSelected;
  final VoidCallback onTap;

  const Coustominterestchip({
    super.key,
    required this.name,      // مطلوب
    required this.icon,      // مطلوب
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // الألوان الأساسية لتسهيل التعديل
    final Color selectedColor = Color(0xFF3B82F6); // أزرق جذاب
    final Color selectedBackgroundColor = Color(0xFFDBEAFE); // أزرق فاتح جداً
    final Color unselectedColor = Colors.grey.shade600;
    final Color unselectedBackgroundColor = Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250), // مدة الحركة
        curve: Curves.easeInOut, // نوع الحركة لجعلها طبيعية
        decoration: BoxDecoration(
          color: isSelected ? selectedBackgroundColor : unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(16), // زوايا أكثر دائرية
          border: Border.all(
            color: isSelected ? selectedColor.withOpacity(0.5) : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            // إضافة ظل ناعم لإعطاء عمق
            if (isSelected)
              BoxShadow(
                color: selectedColor.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none, // للسماح للأيقونة بالظهور خارج الإطار قليلاً
          children: [
            // المحتوى الرئيسي (الأيقونة والنص)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    // --- التعديل 2: استخدام المتغير الجديد ---
                    icon,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    // --- التعديل 3: استخدام المتغير الجديد ---
                    name,
                    style: TextStyle(
                      color: isSelected ? selectedColor : Colors.black87,
                      fontWeight: FontWeight.bold, // خط أعرض
                      fontFamily: "Cairo",
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // أيقونة التحقق العائمة (لا تغيير هنا، الكود ممتاز)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.linear,
              top: isSelected ? -10 : -50,
              right: -8,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: selectedColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
