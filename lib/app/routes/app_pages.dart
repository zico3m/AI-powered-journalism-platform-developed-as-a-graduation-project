// lib/app/routes/app_pages.dart
import 'package:get/get.dart';

import '../bindings/SplashBinding.dart';
import '../controller/editor/bindings/editor_binding.dart';
import '../view/LogIn/ForgetPassword.dart';
import '../view/LogIn/Login_View.dart';
import '../view/LogIn/new_password_screen.dart';
import '../view/LogIn/register_view.dart';
import '../view/LogIn/verify_reset_screen.dart';
import '../view/editor/createnews/create_news_view.dart';
import '../view/editor/editordshpord/editor_home_view.dart';
import '../view/home/Home_main_view.dart';
import '../view/interest/interest_view.dart';
import '../view/onboarding/onboarding_view.dart';
import '../view/RootViews/RootView.dart';
import '../view/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(), // <-- 2. إضافة الـ Binding هنا
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingView(),
    ),

    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
    ),

    GetPage(
      name: AppRoutes.FORGETPASSWORD,
      page: () => ForgetPassword(),
    ),

    GetPage(
      name: AppRoutes.INTEREST,
      page: () => InterestView(),
    ),

    GetPage(
      name: AppRoutes.HOME,
      page: () => RootView(),
    ),

    GetPage(
      name: AppRoutes.VERIFY_RESET,
      page: () => VerifyResetScreen(),
    ),
    GetPage(
      name: AppRoutes.NEW_PASSWORD,
      page: () => NewPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.FORGETPASSWORD,
      page: () => ForgetPassword(),
    ),

    GetPage(
      name: AppRoutes.VERIFY_RESET,
      page: () => VerifyResetScreen(),
    ),

    GetPage(
      name: AppRoutes.NEW_PASSWORD,
      page: () => NewPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.createNews,
      page: () => CreateNewsView(),
    ),
    GetPage(
      name: AppRoutes.editorHome,
      page: () => EditorHomeView(),
      binding: EditorBinding(),
    ),
    // ... باقي الصفحات
  ];
}
