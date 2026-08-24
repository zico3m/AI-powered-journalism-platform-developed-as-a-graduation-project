// // lib/app/controller/profile/ProfileController.dart
// import 'dart:ffi';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../models/data/services/SupabaseService.dart';
//
// class ProfileController extends GetxController {
//   final SupabaseClient _client = SupabaseService.to.client;
//   final userTypeId = 0.obs;
//   //----------- حالة الواجهة -----------
//   final isLoading = true.obs;
//   final isEditing = false.obs;
//   final isSaving = false.obs;
//   final accountTypeId = 0.obs;
//   final hasPendingUpgradeRequest = false.obs;
//
//   //----------- البيانات الأساسية -----------
//   final name = ''.obs;
//   final email = ''.obs;
//   final profileImageUrl = RxnString();
//   final accountTypeName = ''.obs;
//   final accountStatusName = ''.obs;
//   final creationDate = Rxn<DateTime>();
//   final interests = <String>[].obs;
//
//   //----------- حقول الإدخال -----------
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//
//   // ملف الصورة المختارة (محلياً)
//   File? selectedImage;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // تحميل بيانات المستخدم عند فتح الشاشة
//     loadProfile();
//
//     // أي تغيير في Rx ينعكس على الـ Controllers
//     ever<String>(name, (v) => nameController.text = v);
//     ever<String>(email, (v) => emailController.text = v);
//   }
//
//   //=====================================
//   //         تحميل بيانات المستخدم
//   //=====================================
//   Future<void> loadProfile() async {
//     try {
//       isLoading.value = true;
//
//       final authUser = _client.auth.currentUser;
//       if (authUser == null) {
//         Get.snackbar('خطأ', 'المستخدم غير مسجل دخولاً');
//         return;
//       }
//
//       email.value = authUser.email ?? "";
//       emailController.text = email.value; // force update
//
//       creationDate.value = DateTime.parse(authUser.createdAt);
//
//       // -------- من جدول users --------
//       final userRow = await _client
//           .from('users')
//           .select('name, picture_url, user_type_id, account_status_id')
//           .eq('id', authUser.id)
//           .maybeSingle();
//
//       if (userRow != null) {
//         name.value = userRow['name'] ?? "";
//         profileImageUrl.value = userRow['picture_url'] as String?;
//         accountTypeId.value = userRow['user_type_id'] ?? 0;   // ← الجديد
//       }
//
//       final pendingRequest = await _client
//           .from('upgrade_requests')
//           .select('id')
//           .eq('user_id', authUser.id)
//           .eq('status_id', 1) // pending
//           .maybeSingle();
//
//       hasPendingUpgradeRequest.value = pendingRequest != null;
//
//
//       // -------- نوع الحساب --------
//       final userTypeId = userRow?['user_type_id'];
//       if (userTypeId != null) {
//         final typeRow = await _client
//             .from('user_types')
//             .select('name')
//             .eq('id', userTypeId)
//             .maybeSingle();
//         accountTypeName.value = (typeRow?['name'] as String?) ?? "غير محدد";
//       } else {
//         accountTypeName.value = "غير محدد";
//       }
//
//       // -------- حالة الحساب --------
//       final accountStatusId = userRow?['account_status_id'];
//       if (accountStatusId != null) {
//         final statusRow = await _client
//             .from('account_status')
//             .select('name')
//             .eq('id', accountStatusId)
//             .maybeSingle();
//         accountStatusName.value =
//             (statusRow?['name'] as String?) ?? "غير محددة";
//       } else {
//         accountStatusName.value = "غير محددة";
//       }
//
//       // -------- الاهتمامات --------
//       final interestRows = await _client
//           .from('interests')
//           .select('categories(name)')
//           .eq('user_id', authUser.id);
//
//       final names = <String>{};
//       for (final row in interestRows as List) {
//         final cat = row['categories'];
//         if (cat != null && cat['name'] != null) {
//           names.add(cat['name'] as String);
//         }
//       }
//       interests.assignAll(names.toList());
//     } catch (e) {
//       debugPrint("Profile load error: $e");
//       Get.snackbar('خطأ', 'فشل في جلب بيانات الملف الشخصي');
//     } finally {
//       isLoading.value = false;
//     }
//
//
//
//   }
//
//   //=====================================
//   //       اختيار صورة (كاميرا / معرض)
//   //=====================================
//   Future<void> pickImage(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final picked =
//       await picker.pickImage(source: source, imageQuality: 80);
//
//       if (picked == null) return;
//
//       selectedImage = File(picked.path);
//
//       // نعرض مسار الصورة مؤقتاً في الواجهة
//       profileImageUrl.value = picked.path;
//     } catch (e) {
//       debugPrint("Pick error: $e");
//       Get.snackbar("خطأ", "فشل في فتح الكاميرا/المعرض");
//     }
//   }
//
//   //=====================================
//   //        حفظ التعديلات
//   //=====================================
//   Future<void> saveProfile() async {
//     try {
//       isSaving.value = true;
//
//       final authUser = _client.auth.currentUser;
//       if (authUser == null) {
//         Get.snackbar("خطأ", "المستخدم غير مسجل دخولاً");
//         return;
//       }
//
//       String? uploadedUrl = profileImageUrl.value;
//
//       //--------- رفع الصورة إن وُجدت ---------
//       if (selectedImage != null) {
//         final fileExt = selectedImage!.path.split('.').last;
//         final fileName = "${authUser.id}.$fileExt";
//
//         await _client.storage.from('profile_images').upload(
//           fileName,
//           selectedImage!,
//           fileOptions: FileOptions(
//             upsert: true,
//             metadata: {
//               "owner": authUser.id, // ← أهم سطر لحل 403
//             },
//           ),
//         );
//
//         uploadedUrl = _client.storage
//             .from('profile_images')
//             .getPublicUrl(fileName);
//       }
//
//
//       //--------- تحديث جدول users ---------
//       await _client.from("users").update({
//         "name": nameController.text.trim(),
//         "picture_url": uploadedUrl,
//       }).eq("id", authUser.id);
//
//       // تحديث القيم في الواجهة
//       name.value = nameController.text.trim();
//       profileImageUrl.value = uploadedUrl;
//       selectedImage = null;
//       isEditing.value = false;
//
//       Get.snackbar("تم", "تم حفظ التعديلات بنجاح",
//           snackPosition: SnackPosition.BOTTOM);
//     } catch (e) {
//       debugPrint("Save error: $e");
//       Get.snackbar("خطأ", "فشل في حفظ التعديلات",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } finally {
//       isSaving.value = false;
//     }
//   }
//
//   //=====================================
//   //       تفعيل / إلغاء وضع التعديل
//   //=====================================
//   void enableEditing() => isEditing.value = true;
//
//   void cancelEditing() {
//     isEditing.value = false;
//     selectedImage = null;
//     loadProfile(); // نرجع آخر بيانات محفوظة من السيرفر
//   }
//
//   String get creationYearText {
//     final c = creationDate.value;
//     return c == null ? "" : "${c.year} تاريخ الإنشاء";
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     super.onClose();
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/services/SupabaseService.dart';
import '../../models/data/services/profaile/profile_repository.dart';

class ProfileController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;
  final ProfileRepository _repo = ProfileRepository();

  // ===== حالات =====
  final isLoading = true.obs;
  final isEditing = false.obs;
  final isSaving = false.obs;
  final hasPendingUpgradeRequest = false.obs;

  // ===== بيانات =====
  final name = ''.obs;
  final email = ''.obs;
  final profileImageUrl = RxnString();
  final accountTypeName = ''.obs;
  final accountStatusName = ''.obs;
  final creationDate = Rxn<DateTime>();
  final interests = <String>[].obs;
  final accountTypeId = 0.obs;

  // ===== Controllers =====
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  File? selectedImage;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    ever(name, (v) => nameController.text = v);
    ever(email, (v) => emailController.text = v);
  }

  // ================= تحميل البيانات =================
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final authUser = _client.auth.currentUser;
      if (authUser == null) return;

      // ===== بيانات أساسية من Auth =====
      emailController.text = authUser.email ?? "";
      email.value = emailController.text;

      creationDate.value = DateTime.parse(authUser.createdAt);

      // ===== بيانات من قاعدة البيانات =====
      final data = await _repo.loadProfile(authUser.id);
      final userRow = data['user'];

      if (userRow != null) {
        name.value = userRow['name'] ?? "";
        profileImageUrl.value = userRow['picture_url'];

        accountTypeId.value = userRow['user_type_id'] ?? 0;

        accountTypeName.value =
        await _repo.getAccountTypeName(accountTypeId.value);

        accountStatusName.value =
        await _repo.getAccountStatusName(
          userRow['account_status_id'],
        );
      }

      // ===== طلب ترقية معلق =====
      hasPendingUpgradeRequest.value = data['hasPending'] ?? false;

      // ===== الاهتمامات =====
      final names = <String>{};
      for (final row in data['interests'] as List) {
        final cat = row['categories'];
        if (cat != null) {
          names.add(cat['name']);
        }
      }
      interests.assignAll(names.toList());

    } catch (e) {
      debugPrint("Profile error: $e");
      Get.snackbar("خطأ", "فشل تحميل الملف الشخصي");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= اختيار صورة =================
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked == null) return;

    selectedImage = File(picked.path);
    profileImageUrl.value = picked.path;
  }

  // ================= حفظ =================
  Future<void> saveProfile() async {
    try {
      isSaving.value = true;

      final user = _client.auth.currentUser;
      if (user == null) return;

      String? imageUrl = profileImageUrl.value;

      if (selectedImage != null) {
        imageUrl = await _repo.uploadProfileImage(selectedImage!, user.id);
      }

      await _repo.updateProfile(
        userId: user.id,
        name: nameController.text.trim(),
        imageUrl: imageUrl,
      );

      name.value = nameController.text.trim();
      profileImageUrl.value = imageUrl;
      selectedImage = null;
      isEditing.value = false;

      Get.snackbar("تم", "تم حفظ التعديلات بنجاح");
    } catch (e) {
      debugPrint("Save error: $e");
      Get.snackbar("خطأ", "فشل حفظ التعديلات");
    } finally {
      isSaving.value = false;
    }
  }

  void enableEditing() => isEditing.value = true;

  void cancelEditing() {
    isEditing.value = false;
    selectedImage = null;
    loadProfile();
  }

  String get creationYearText =>
      creationDate.value == null ? "" : "${creationDate.value!.year} تاريخ الإنشاء";

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
