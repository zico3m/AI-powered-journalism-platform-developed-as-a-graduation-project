import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/data/services/SupabaseService.dart';
void showReportDialog(BuildContext context, int articleId) {
  final client = SupabaseService.to.client;
  final selectedReason = RxnInt();

  Get.dialog(
    AlertDialog(
      title: const Text(
        "الإبلاغ عن المقال",
        style: TextStyle(fontFamily: "Cairo"),
      ),
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _reportOption(1, "محتوى غير لائق", selectedReason),
            _reportOption(2, "محتوى مضلل أو كاذب", selectedReason),
            _reportOption(3, "خطاب كراهية أو عنف", selectedReason),
            _reportOption(4, "انتهاك حقوق", selectedReason),
            _reportOption(5, "احتيال أو تضليل", selectedReason),
          ],
        );
      }),
      actions: [
        TextButton(
          child: const Text("إلغاء"),
          onPressed: () => Get.back(),
        ),
        ElevatedButton(
          child: const Text("إرسال البلاغ"),
          onPressed: () async {
            if (selectedReason.value == null) {
              Get.snackbar("تنبيه", "يرجى اختيار سبب البلاغ");
              return;
            }

            final user = client.auth.currentUser;
            if (user == null) {
              Get.snackbar("تنبيه", "يجب تسجيل الدخول");
              return;
            }

            await client.from('article_reports').insert({
              'article_id': articleId,
              'user_id': user.id,
              'reason_id': selectedReason.value,
            });

            Get.back();
            Get.snackbar(
              "تم",
              "تم إرسال بلاغك وسيتم مراجعته",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ],
    ),
  );
}

Widget _reportOption(
    int id,
    String label,
    RxnInt selectedReason,
    ) {
  return RadioListTile<int>(
    value: id,
    groupValue: selectedReason.value,
    onChanged: (v) => selectedReason.value = v,
    title: Text(
      label,
      style: const TextStyle(fontFamily: "Cairo"),
    ),
  );
}


Widget _buildOption(
    int id,
    String label,
    int? selected,
    void Function(void Function()) setState,
    ) {
  return RadioListTile<int>(
    value: id,
    groupValue: selected,
    onChanged: (v) {
      setState(() {
        selected = v;
      });
    },
    title: Text(label, style: const TextStyle(fontFamily: "Cairo")),
  );
}
