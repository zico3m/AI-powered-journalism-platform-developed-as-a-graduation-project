// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nabaa/app/core/constants/app_colors.dart';
// import 'package:nabaa/app/core/constants/app_fonts.dart';
// import 'package:nabaa/app/routes/app_routes.dart';
//
// import '../../controllers/auth/login_controller.dart';
// import '../../controllers/auth/register_controller.dart';
// import '../../core/constants/app_images.dart';
// import '../../widgets/CoustomTextFiledForm.dart';
// import '../../widgets/CustomContainerButton.dart';
//
// class LoginView extends StatelessWidget {
//   final LoginController controller = Get.put(LoginController());
//
//   LoginView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final padding = size.width * 0.08;
//
//     return Scaffold(
//       backgroundColor: AppColor.background,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
//             child: Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColor.cardbackground,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 12,
//                     spreadRadius: 2,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 150,
//                     height: 170,
//                     child: Lottie.asset(
//                       AppImages.login,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//
//                   // Name
//
//                   // Email
//                   CustomTextFieldForm(
//                     errorText: controller.emailError,
//                     onChanged: (val) => controller.email.value = val,
//                     obscured: false,
//                     hintText: "البريد الإلكتروني",
//                     suffixIcon: Icon(Icons.email),
//                   ),
//
//                   // Password
//                   Obx(
//                     () => CustomTextFieldForm(
//                       errorText: controller.passError,
//                       onChanged: (val) => controller.passowrd.value = val,
//                       obscured: controller.isPasowardHidding.value,
//                       hintText: "كلمة المرور",
//                       suffixIcon: GestureDetector(
//                         onTap: () => controller.toGglepaassowardViasbility(),
//                         child: Icon(
//                           controller.isPasowardHidding.value
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: controller.isPasowardHidding.value
//                               ? Colors.blueAccent
//                               : Colors.red,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // Confirm Password
//                   SizedBox(height: size.height * 0.03),
//
//                   // Register Button
//                   CustomContainerButton(
//                     text: "إنشاء حساب",
//                     onTap: controller.logIN,
//                   ),
//
//                   SizedBox(height: size.height * 0.02),
//
//                   // Login Redirect
//                   TextButton(
//                     onPressed: () {
//                     },
//                     child: Text(
//                       "هل لديك حساب ؟ تسجيل دخول",
//                       style: TextStyle(
//                         color: AppColor.botom,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: size.height * 0.01),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
