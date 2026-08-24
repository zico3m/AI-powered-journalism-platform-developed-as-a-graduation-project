import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/services/SupabaseService.dart';
import '../profile/ProfileController.dart';

class UpgradeRequestController extends GetxController {
  final SupabaseClient _client = SupabaseService.to.client;

  final isSubmitting = false.obs;


  final fullNameController = TextEditingController();
  final nationalIdController = TextEditingController();
  final reasonController = TextEditingController();


  final documentTypes = <Map<String, dynamic>>[].obs;
  final selectedDocumentTypeId = RxnInt();

  final selectedDocuments = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDocumentTypes();
  }

  Future<void> loadDocumentTypes() async {
    try {
      final res =
          await _client.from('document_types').select('id, name').order('id');

      documentTypes.assignAll(
        List<Map<String, dynamic>>.from(res),
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب أنواع الوثائق');
    }
  }


  Future<void> pickDocumentImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      selectedDocuments.add(File(picked.path));
    }
  }


  void removeDocument(int index) {
    selectedDocuments.removeAt(index);
  }


  Future<void> submitUpgradeRequest() async {
    if (!validateForm()) return;

    final user = _client.auth.currentUser;
    if (user == null) {
      Get.snackbar('خطأ', 'المستخدم غير مسجل دخولاً');
      return;
    }

    try {
      isSubmitting.value = true;

      final pending = await _client
          .from('upgrade_requests')
          .select('id')
          .eq('user_id', user.id)
          .eq('status_id', 1) // pending
          .maybeSingle();

      if (pending != null) {
        Get.snackbar(
          'تنبيه',
          'لديك طلب ترقية قيد المراجعة بالفعل',
        );
        return;
      }

      final inserted = await _client
          .from('upgrade_requests')
          .insert({
            'user_id': user.id,
            'full_name': fullNameController.text.trim(),
            'national_id': nationalIdController.text.trim(),
            'id_type_id': selectedDocumentTypeId.value,
            'reason': reasonController.text.trim(),
            'status_id': 1, // pending
          })
          .select('id')
          .single();

      final requestId = inserted['id'];


      for (final file in selectedDocuments) {
        final ext = file.path.split('.').last;
        final fileName =
            '$requestId/${DateTime.now().millisecondsSinceEpoch}.$ext';

        // رفع الملف إلى Supabase Storage
        await _client.storage
            .from('upgrade_documents')
            .upload(
          fileName,
          file,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

        // الحصول على الرابط العام
        final fileUrl = _client.storage
            .from('upgrade_documents')
            .getPublicUrl(fileName);

        // حفظ بيانات الملف في قاعدة البيانات
        await _client.from('upgrade_request_documents').insert({
          'upgrade_request_id': requestId,
          'document_type_id': selectedDocumentTypeId.value,
          'file_url': fileUrl,
          'uploaded_at': DateTime.now().toIso8601String(),
        });
      }

      final profileController = Get.find<ProfileController>();
      profileController.hasPendingUpgradeRequest.value = true;

      Get.back();
      Get.snackbar(
        'تم الإرسال',
        'تم إرسال طلب الترقية بنجاح وسيتم مراجعته من الإدارة',
        snackPosition: SnackPosition.BOTTOM,
      );
    }catch (e) {
      debugPrint('Upgrade request error: $e');
      Get.snackbar('خطأ', e.toString());
    }
    finally {
      isSubmitting.value = false;
    }

    final res = await _client.storage.from('upgrade_documents').list();

    print(res);
  }


  bool validateForm() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الاسم الكامل مطلوب');
      return false;
    }

    if (nationalIdController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'رقم الهوية مطلوب');
      return false;
    }

    if (selectedDocumentTypeId.value == null) {
      Get.snackbar('تنبيه', 'يرجى اختيار نوع الهوية');
      return false;
    }

    if (selectedDocuments.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إرفاق صورة واحدة على الأقل للهوية',
      );
      return false;
    }

    if (reasonController.text.trim().length < 10) {
      Get.snackbar(
        'تنبيه',
        'سبب الطلب يجب أن يكون أوضح',
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    nationalIdController.dispose();
    reasonController.dispose();
    super.onClose();
  }
}
