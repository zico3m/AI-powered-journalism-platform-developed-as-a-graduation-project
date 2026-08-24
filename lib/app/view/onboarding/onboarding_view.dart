import 'package:flutter/material.dart';
import 'package:get/get.dart'; // سنبقيها فقط للانتقال بين الصفحات
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:introduction_screen/introduction_screen.dart';

// --- استيراد الثوابت الخاصة بك ---

import '../../core/app_colors.dart';
import '../../core/app_fonts.dart';
import '../../core/app_images.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart'; // افترضت أن لديك ملف لأسماء المسارات

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  // دالة للانتقال إلى الصفحة التالية بعد الانتهاء
  void _onIntroEnd() {
    final box = GetStorage();
    box.write('seenOnboarding', true);

    // --- انتقل إلى السبلاش، وهي ستقرر الوجهة التالية ---
    Get.offAllNamed(AppRoutes.SPLASH);
  }

  @override
  Widget build(BuildContext context) {
    // تعريف ستايل الصفحات مرة واحدة لإعادة استخدامه
    final pageDecoration = PageDecoration(
      // استخدم المتغيرات الخاصة بك من AppFonts
      titleTextStyle: AppFonts.TitleStyle.copyWith(fontSize: 24),
      bodyTextStyle: AppFonts.titilebody.copyWith(fontSize: 18, height: 1.5),
      // تعديل الـ padding ليتناسب مع تصميمك
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // لون خلفية كل صفحة
      pageColor: AppColor.background,
      // المسافة حول الصورة
      imagePadding: const EdgeInsets.only(bottom: 24.0),
    );

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: IntroductionScreen(
          key: GlobalKey<IntroductionScreenState>(),
          // تعطيل التمرير الأفقي إذا أردت التحكم فقط عبر الأزرار
          freeze: false,
          // قائمة الصفحات
          pages: [
            _buildPageViewModel(
              title: "اقرأ الأخبار وقتما تشاء",
              imagePath: AppImages.smartphone,
              body: "تابع آخر المستجدات من مصادر موثوقة \n بتصنيفات متنوعة تلبي اهتماماتك",
              decoration: pageDecoration,
            ),
            _buildPageViewModel(
              title: "استمع بدل القراءة",
              imagePath: AppImages.LisenToNews,
              body: "حوّل الأخبار إلى تجربة صوتية \n واستمع إليها أثناء انشغالك أو تنقلك",
              decoration: pageDecoration,
            ),
            _buildPageViewModel(
              title: "كن أول من يعرف",
              imagePath: AppImages.readingNews,
              body: "اختر مصادر وتصنيفاتك المفضلة، واحصل على إشعارات فورية عند نشر أي خبر جديد",
              decoration: pageDecoration,
            ),
          ],
          // عند الضغط على زر "تم" في آخر صفحة
          onDone: _onIntroEnd,
          // عند الضغط على زر "تخطي"
          onSkip: _onIntroEnd,

          // --- تخصيص شكل الأزرار ---
          showSkipButton: true,
          skip: Text('تخطي', style: AppFonts.TitleStyle.copyWith(fontSize: 16, color: AppColor.primary)),
          next: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          done: Text('ابدأ', style: AppFonts.TitleStyle.copyWith(fontSize: 16, color: AppColor.primary)),

          // --- تخصيص شكل نقاط التنقل (Dots) ---
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.grey,
            activeColor: Colors.blueAccent, // يمكنك استخدام AppColor.botom
            activeSize: const Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء كل صفحة بشكل منظم
  PageViewModel _buildPageViewModel({
    required String title,
    required String imagePath,
    required String body,
    required PageDecoration decoration,
  }) {
    return PageViewModel(
      title: title,
      body: body,
      image: Center(
        child: Lottie.asset(imagePath, fit: BoxFit.contain),
      ),
      decoration: decoration,
    );
  }
}
